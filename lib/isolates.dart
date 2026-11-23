import 'package:built_collection/built_collection.dart';
import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';

import 'model.dart';
import 'utils.dart';

/// Explores crossword solutions using a [WorkQueue], trying candidate words
/// in a background isolate, and yields each valid [Crossword] found until
/// there are no more locations or words to try.
Stream<Crossword> exploreCrosswordSolutions({
  required Crossword crossword,
  required BuiltSet<String> wordList,
}) async* {
  final start = DateTime.now();
  var workQueue = WorkQueue.from(
    crossword: crossword,
    candidateWords: wordList,
    startLocation: Location.at(0, 0),
  );

  while (!workQueue.isCompleted) {
    final location = workQueue.locationsToTry.keys
        .toBuiltSet()
        .randomElement();
    try {
      final result = await compute(_tryLocation, (workQueue, location));
      if (result != null) {
        workQueue = workQueue.updateFrom(result);
        yield result;
      } else {
        workQueue = workQueue.remove(location);
      }
    } catch (e) {
      debugPrint('Error running isolate: $e');
      workQueue = workQueue.remove(location);
    }
  }

  debugPrint(
    '${crossword.width} x ${crossword.height} Crossword generation took: '
    '${DateTime.now().difference(start).formatted}',
  );
}

/// Runs in a background isolate. Tries to place a word through [location],
/// returning the new crossword, or null if no candidate word fits.
Crossword? _tryLocation((WorkQueue, Location) workMessage) {
  final (workQueue, location) = workMessage;
  final direction = workQueue.locationsToTry[location]!;
  final target = workQueue.crossword.characters[location];

  // An empty location: start the crossword with any word.
  if (target == null) {
    return workQueue.crossword.addWord(
      direction: direction,
      location: location,
      word: workQueue.candidateWords.randomElement(),
    );
  }

  // Only words containing the target character can cross this location.
  final words = workQueue.candidateWords.toBuiltList().rebuild(
    (b) => b
      ..where((word) => word.characters.contains(target.character))
      ..shuffle(),
  );

  var tryCount = 0;
  for (final word in words) {
    tryCount++;
    for (final (index, character) in word.characters.indexed) {
      if (character != target.character) continue;

      final candidate = workQueue.crossword.addWord(
        location: switch (direction) {
          Direction.across => location.leftOffset(index),
          Direction.down => location.upOffset(index),
        },
        word: word,
        direction: direction,
      );
      if (candidate != null) {
        return candidate;
      }
    }
    if (tryCount >= 1000) break;
  }

  return null;
}
