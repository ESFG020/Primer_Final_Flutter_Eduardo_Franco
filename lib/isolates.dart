import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/foundation.dart';

import 'model.dart';
import 'utils.dart';

final _random = Random();

/// Explores crossword solutions by repeatedly trying random word placements
/// in a background isolate, yielding each valid [Crossword] found until 80%
/// of the grid's cells are filled.
Stream<Crossword> exploreCrosswordSolutions({
  required Crossword crossword,
  required BuiltSet<String> wordList,
}) async* {
  while (crossword.characters.length <
      crossword.width * crossword.height * 0.8) {
    final candidate = await compute(_generateCandidate, (crossword, wordList));
    if (candidate != null) {
      crossword = candidate;
      yield crossword;
    }
  }

  yield crossword;
}

/// Runs in a background isolate. Tries up to 1000 random placements and
/// returns the first valid one, or null if none fit.
Crossword? _generateCandidate((Crossword, BuiltSet<String>) args) {
  final (crossword, wordList) = args;
  for (var i = 0; i < 1000; i++) {
    final word = wordList.randomElement();
    final direction = _random.nextBool() ? Direction.across : Direction.down;
    final location = Location.at(
      _random.nextInt(crossword.width),
      _random.nextInt(crossword.height),
    );

    final candidate = crossword.addWord(
      word: word,
      direction: direction,
      location: location,
    );
    if (candidate != null) {
      return candidate;
    }
  }
  return null;
}
