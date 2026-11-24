import 'package:built_collection/built_collection.dart';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';

import 'model.dart';
import 'utils.dart';

/// Explores crossword solutions using a [WorkQueue]. Each step runs in a
/// background isolate that fans out up to [maxWorkerCount] parallel workers,
/// and the updated [WorkQueue] is yielded after every step until there are
/// no more locations or words to try.
Stream<WorkQueue> exploreCrosswordSolutions({
  required Crossword crossword,
  required BuiltSet<String> wordList,
  required int maxWorkerCount,
}) async* {
  final start = DateTime.now();
  var workQueue = WorkQueue.from(
    crossword: crossword,
    candidateWords: wordList,
    startLocation: Location.at(0, 0),
  );

  while (!workQueue.isCompleted) {
    try {
      workQueue = await compute(_generate, (workQueue, maxWorkerCount));
      yield workQueue;
    } catch (e) {
      debugPrint('Error running isolate: $e');
    }
  }

  debugPrint(
    'Generated ${workQueue.crossword.width} x ${workQueue.crossword.height} '
    'crossword in ${DateTime.now().difference(start).formatted} '
    'with $maxWorkerCount workers.',
  );
}

/// Runs in a background isolate. Dispatches up to [maxWorkerCount] workers in
/// parallel, each exploring a different location, then merges their results
/// into the work queue.
Future<WorkQueue> _generate((WorkQueue, int) workMessage) async {
  var (workQueue, maxWorkerCount) = workMessage;
  final candidateGeneratorFutures = <Future<(Location, Direction, String?)>>[];
  final locations = workQueue.locationsToTry.keys.toBuiltList().rebuild(
    (b) => b
      ..shuffle()
      ..take(maxWorkerCount),
  );

  for (final location in locations) {
    final direction = workQueue.locationsToTry[location]!;

    candidateGeneratorFutures.add(
      compute(_generateCandidate, (
        workQueue.crossword,
        workQueue.candidateWords,
        location,
        direction,
      )),
    );
  }

  try {
    final results = await candidateGeneratorFutures.wait;
    var crossword = workQueue.crossword;
    for (final (location, direction, word) in results) {
      if (word != null) {
        // Workers ran against the same snapshot, so a word may now clash with
        // one placed by another worker; addWord rejects it in that case and
        // the location stays in the queue to retry.
        final candidate = crossword.addWord(
          location: location,
          word: word,
          direction: direction,
        );
        if (candidate != null) {
          crossword = candidate;
        }
      } else {
        workQueue = workQueue.remove(location);
      }
    }

    workQueue = workQueue.updateFrom(crossword);
  } catch (e) {
    debugPrint('$e');
  }

  return workQueue;
}

/// Runs in a worker isolate. Searches for a word that crosses [location] in
/// [direction]. Returns the start location, direction and word found, or the
/// original location with a null word if nothing fits within 1,000 tries or
/// 10 seconds.
(Location, Direction, String?) _generateCandidate(
  (Crossword, BuiltSet<String>, Location, Direction) searchDetailMessage,
) {
  final (crossword, candidateWords, location, direction) = searchDetailMessage;

  final target = crossword.characters[location];
  if (target == null) {
    return (location, direction, candidateWords.randomElement());
  }

  // Only words containing the target character can cross this location.
  final words = candidateWords.toBuiltList().rebuild(
    (b) => b
      ..where((word) => word.characters.contains(target.character))
      ..shuffle(),
  );

  var tryCount = 0;
  final start = DateTime.now();
  for (final word in words) {
    tryCount++;
    for (final (index, character) in word.characters.indexed) {
      if (character != target.character) continue;

      final wordLocation = switch (direction) {
        Direction.across => location.leftOffset(index),
        Direction.down => location.upOffset(index),
      };
      final candidate = crossword.addWord(
        location: wordLocation,
        word: word,
        direction: direction,
      );
      if (candidate != null) {
        return (wordLocation, direction, word);
      }
    }

    if (tryCount >= 1000 ||
        DateTime.now().difference(start) > const Duration(seconds: 10)) {
      break;
    }
  }

  return (location, direction, null);
}
