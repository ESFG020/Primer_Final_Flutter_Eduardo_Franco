import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'isolates.dart';
import 'model.dart' as model;

part 'providers.g.dart';

/// A provider for the wordlist to use when generating the crossword.
@riverpod
Future<BuiltSet<String>> wordList(Ref ref) async {
  // This codebase requires that all words consist of lowercase characters
  // in the range 'a'-'z'. Words containing uppercase letters will be
  // lowercased, and words containing runes outside this range will
  // be removed.

  final re = RegExp(r'^[a-z]+$');
  final words = await rootBundle.loadString('assets/words.txt');
  return const LineSplitter().convert(words).toBuiltSet().rebuild(
    (b) => b
      ..map((word) => word.toLowerCase().trim())
      ..where((word) => word.length > 2)
      ..where((word) => re.hasMatch(word)),
  );
}

/// An enumeration for different sizes of [model.Crossword]s.
enum CrosswordSize {
  small(width: 20, height: 11),
  medium(width: 40, height: 22),
  large(width: 80, height: 44),
  xlarge(width: 160, height: 88),
  xxlarge(width: 500, height: 500);

  const CrosswordSize({required this.width, required this.height});

  final int width;
  final int height;
  String get label => '$width x $height';
}

/// A provider that holds the current size of the crossword to generate.
@Riverpod(keepAlive: true)
class Size extends _$Size {
  @override
  CrosswordSize build() => CrosswordSize.medium;

  void setSize(CrosswordSize size) {
    state = size;
  }
}

/// A provider that generates a crossword in background isolates, streaming
/// the [model.WorkQueue] state on each step of the search.
@riverpod
Stream<model.WorkQueue> workQueue(Ref ref) async* {
  const backgroundWorkerCount = 4;
  final size = ref.watch(sizeProvider);
  final wordListAsync = ref.watch(wordListProvider);

  final emptyCrossword = model.Crossword.crossword(
    width: size.width,
    height: size.height,
  );
  final emptyWorkQueue = model.WorkQueue.from(
    crossword: emptyCrossword,
    candidateWords: BuiltSet<String>(),
    startLocation: model.Location.at(0, 0),
  );

  yield* wordListAsync.when(
    data: (wordList) => exploreCrosswordSolutions(
      crossword: emptyCrossword,
      wordList: wordList,
      maxWorkerCount: backgroundWorkerCount,
    ),
    error: (error, stackTrace) async* {
      debugPrint('Error loading word list: $error');
      yield emptyWorkQueue;
    },
    loading: () async* {
      yield emptyWorkQueue;
    },
  );
}

/// The puzzle the player is solving. Starts empty, and is built from the
/// generated crossword once generation completes.
@riverpod
class Puzzle extends _$Puzzle {
  @override
  model.CrosswordPuzzleGame build() {
    final size = ref.watch(sizeProvider);
    final wordList = ref.watch(wordListProvider).value;
    final workQueue = ref.watch(workQueueProvider).value;

    // Only build a real puzzle once the crossword is finished.
    if (wordList != null && workQueue != null && workQueue.isCompleted) {
      final crossword = workQueue.crossword;
      compute(_puzzleFromCrosswordTrampoline, (crossword, wordList)).then((
        puzzle,
      ) {
        // Ignore the result if the crossword changed while it was computed.
        if (ref.mounted) {
          state = puzzle;
        }
      });
    }

    return model.CrosswordPuzzleGame.from(
      crossword: model.Crossword.crossword(
        width: size.width,
        height: size.height,
      ),
      candidateWords: BuiltSet<String>(),
    );
  }

  /// Select [word] for the slot at [location] in [direction].
  Future<void> selectWord({
    required model.Location location,
    required String word,
    required model.Direction direction,
  }) async {
    final candidate = await compute(_puzzleSelectWordTrampoline, (
      state,
      location,
      word,
      direction,
    ));

    if (!ref.mounted) return;
    if (candidate != null) {
      state = candidate;
    } else {
      debugPrint('Invalid word selection: $word');
    }
  }

  /// Whether [word] can be selected for the slot at [location] in
  /// [direction].
  bool canSelectWord({
    required model.Location location,
    required String word,
    required model.Direction direction,
  }) {
    return state.canSelectWord(
      location: location,
      word: word,
      direction: direction,
    );
  }
}

/// Builds a puzzle in a background isolate.
model.CrosswordPuzzleGame _puzzleFromCrosswordTrampoline(
  (model.Crossword, BuiltSet<String>) inputs,
) => model.CrosswordPuzzleGame.from(
  crossword: inputs.$1,
  candidateWords: inputs.$2,
);

/// Applies a word selection in a background isolate.
model.CrosswordPuzzleGame? _puzzleSelectWordTrampoline(
  (model.CrosswordPuzzleGame, model.Location, String, model.Direction) inputs,
) {
  final (puzzle, location, word, direction) = inputs;
  return puzzle.selectWord(
    location: location,
    word: word,
    direction: direction,
  );
}
