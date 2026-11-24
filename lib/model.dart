import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:characters/characters.dart';
import 'package:intl/intl.dart';

part 'model.g.dart';

/// A location in a crossword.
abstract class Location implements Built<Location, LocationBuilder> {
  static Serializer<Location> get serializer => _$locationSerializer;

  /// The horizontal part of the location. The location is 0 based.
  int get x;

  /// The vertical part of the location. The location is 0 based.
  int get y;

  /// Returns a new location that is one step to the left of this location.
  Location get left => rebuild((b) => b.x = x - 1);

  /// Returns a new location that is one step to the right of this location.
  Location get right => rebuild((b) => b.x = x + 1);

  /// Returns a new location that is one step up from this location.
  Location get up => rebuild((b) => b.y = y - 1);

  /// Returns a new location that is one step down from this location.
  Location get down => rebuild((b) => b.y = y + 1);

  /// Returns a new location that is [offset] steps to the left of this location.
  Location leftOffset(int offset) => rebuild((b) => b.x = x - offset);

  /// Returns a new location that is [offset] steps to the right of this location.
  Location rightOffset(int offset) => rebuild((b) => b.x = x + offset);

  /// Returns a new location that is [offset] steps up from this location.
  Location upOffset(int offset) => rebuild((b) => b.y = y - offset);

  /// Returns a new location that is [offset] steps down from this location.
  Location downOffset(int offset) => rebuild((b) => b.y = y + offset);

  /// Pretty print a location as a (x,y) coordinate.
  String prettyPrint() => '(${x.toString().padLeft(3)},${y.toString().padLeft(3)})';

  /// Returns a new location built from [updates]. Both [x] and [y] are
  /// required to be non-null.
  factory Location([void Function(LocationBuilder)? updates]) = _$Location;
  Location._();

  /// Returns a location at [x], [y].
  factory Location.at(int x, int y) {
    return Location((b) {
      b
        ..x = x
        ..y = y;
    });
  }
}

/// The direction of a word in a crossword.
enum Direction {
  across,
  down;

  @override
  String toString() => name;
}

/// A word in a crossword. This is a word placed in the crossword at a
/// [location] in a [direction].
abstract class CrosswordWord
    implements Built<CrosswordWord, CrosswordWordBuilder> {
  static Serializer<CrosswordWord> get serializer => _$crosswordWordSerializer;

  /// The word itself.
  String get word;

  /// The location of this word in the crossword.
  Location get location;

  /// The direction of this word in the crossword.
  Direction get direction;

  /// Compare two CrosswordWord by coordinates, x then y.
  static int locationComparator(CrosswordWord a, CrosswordWord b) {
    final compareRows = a.location.y.compareTo(b.location.y);
    final compareColumns = a.location.x.compareTo(b.location.x);
    return switch (compareColumns) {
      0 => compareRows,
      _ => compareColumns,
    };
  }

  /// Constructor for [CrosswordWord].
  factory CrosswordWord.word({
    required String word,
    required Location location,
    required Direction direction,
  }) {
    return CrosswordWord(
      (b) => b
        ..word = word
        ..direction = direction
        ..location.replace(location),
    );
  }

  /// Constructor for [CrosswordWord].
  /// Use [CrosswordWord.word] instead.
  factory CrosswordWord([void Function(CrosswordWordBuilder)? updates]) =
      _$CrosswordWord;
  CrosswordWord._();
}

/// A character in a crossword. This is a single character at a location in a
/// crossword. A character can be part of an across word, a down word, both,
/// but not neither.
abstract class CrosswordCharacter
    implements Built<CrosswordCharacter, CrosswordCharacterBuilder> {
  static Serializer<CrosswordCharacter> get serializer =>
      _$crosswordCharacterSerializer;

  /// The character at this location.
  String get character;

  /// The across word that this character is a part of.
  CrosswordWord? get acrossWord;

  /// The down word that this character is a part of.
  CrosswordWord? get downWord;

  /// Constructor for [CrosswordCharacter].
  /// [acrossWord] and [downWord] are optional.
  factory CrosswordCharacter.character({
    required String character,
    CrosswordWord? acrossWord,
    CrosswordWord? downWord,
  }) {
    return CrosswordCharacter((b) {
      b.character = character;
      if (acrossWord != null) {
        b.acrossWord.replace(acrossWord);
      }
      if (downWord != null) {
        b.downWord.replace(downWord);
      }
    });
  }

  /// Constructor for [CrosswordCharacter].
  /// Use [CrosswordCharacter.character] instead.
  factory CrosswordCharacter([
    void Function(CrosswordCharacterBuilder)? updates,
  ]) = _$CrosswordCharacter;
  CrosswordCharacter._();
}

/// A crossword puzzle. This is a grid of characters with words placed in it.
/// The puzzle constraint is in the English crossword puzzle tradition.
abstract class Crossword implements Built<Crossword, CrosswordBuilder> {
  static Serializer<Crossword> get serializer => _$crosswordSerializer;

  /// Width across the [Crossword] puzzle.
  int get width;

  /// Height down the [Crossword] puzzle.
  int get height;

  /// The words in the crossword.
  BuiltList<CrosswordWord> get words;

  /// The characters by location. Useful for displaying the crossword.
  BuiltMap<Location, CrosswordCharacter> get characters;

  /// Checks if this crossword is valid, following the English crossword
  /// tradition.
  bool get valid {
    // Check that there are no duplicate words.
    final wordSet = words.map((word) => word.word).toBuiltSet();
    if (wordSet.length != words.length) {
      return false;
    }

    for (final MapEntry(key: location, value: character)
        in characters.entries) {
      // All characters must be a part of an across or down word.
      if (character.acrossWord == null && character.downWord == null) {
        return false;
      }

      // All characters must be within the crossword puzzle.
      // No drawing outside the lines.
      if (location.x < 0 ||
          location.y < 0 ||
          location.x >= width ||
          location.y >= height) {
        return false;
      }

      // Characters above and below this character must be related
      // by a vertical word.
      if (characters[location.up] case final up?) {
        if (character.downWord == null) {
          return false;
        }
        if (up.downWord != character.downWord) {
          return false;
        }
      }

      if (characters[location.down] case final down?) {
        if (character.downWord == null) {
          return false;
        }
        if (down.downWord != character.downWord) {
          return false;
        }
      }

      // Characters to the left and right of this character must be
      // related by a horizontal word.
      final left = characters[location.left];
      if (left != null) {
        if (character.acrossWord == null) {
          return false;
        }
        if (left.acrossWord != character.acrossWord) {
          return false;
        }
      }

      final right = characters[location.right];
      if (right != null) {
        if (character.acrossWord == null) {
          return false;
        }
        if (right.acrossWord != character.acrossWord) {
          return false;
        }
      }
    }

    return true;
  }

  /// Add a word to the crossword at the given location and direction.
  /// Returns null if the word can't be added to the crossword. When
  /// [requireOverlap] is true, every word after the first must cross an
  /// existing word.
  Crossword? addWord({
    required Location location,
    required String word,
    required Direction direction,
    bool requireOverlap = true,
  }) {
    // Require that the word is not empty and not already in the crossword.
    if (word.isEmpty ||
        words.map((crosswordWord) => crosswordWord.word).contains(word)) {
      return null;
    }

    final wordCharacters = word.characters;
    bool overlap = false;

    // Check that the word fits in the crossword.
    for (final (index, character) in wordCharacters.indexed) {
      final characterLocation = switch (direction) {
        Direction.across => location.rightOffset(index),
        Direction.down => location.downOffset(index),
      };

      final target = characters[characterLocation];
      if (target != null) {
        overlap = true;
        if (target.character != character) {
          return null;
        }
        if (direction == Direction.across && target.acrossWord != null ||
            direction == Direction.down && target.downWord != null) {
          return null;
        }
      }
    }

    // Every word after the first must cross an existing word.
    if (requireOverlap && words.isNotEmpty && !overlap) {
      return null;
    }

    final candidate = rebuild(
      (b) => b
        ..words.add(
          CrosswordWord.word(
            word: word,
            direction: direction,
            location: location,
          ),
        ),
    );

    if (candidate.valid) {
      return candidate;
    } else {
      return null;
    }
  }

  /// As a finalize step, fill in the characters map.
  @BuiltValueHook(finalizeBuilder: true)
  static void _fillCharacters(CrosswordBuilder b) {
    b.characters.clear();

    for (final word in b.words.build()) {
      for (final (idx, character) in word.word.characters.indexed) {
        switch (word.direction) {
          case Direction.across:
            b.characters.updateValue(
              word.location.rightOffset(idx),
              (b) => b.rebuild((bInner) => bInner.acrossWord.replace(word)),
              ifAbsent: () => CrosswordCharacter.character(
                acrossWord: word,
                character: character,
              ),
            );
          case Direction.down:
            b.characters.updateValue(
              word.location.downOffset(idx),
              (b) => b.rebuild((bInner) => bInner.downWord.replace(word)),
              ifAbsent: () => CrosswordCharacter.character(
                downWord: word,
                character: character,
              ),
            );
        }
      }
    }
  }

  /// Pretty print a crossword. Generates the character grid, and lists
  /// the down words and across words sorted by location.
  String prettyPrintCrossword() {
    final buffer = StringBuffer();
    final grid = List.generate(
      height,
      (_) => List.generate(
        width,
        (_) => '░', // https://www.compart.com/en/unicode/U+2591
      ),
    );

    for (final MapEntry(key: Location(:x, :y), value: character)
        in characters.entries) {
      if (x >= 0 && x < width && y >= 0 && y < height) {
        grid[y][x] = character.character;
      }
    }

    for (final row in grid) {
      buffer.writeln(row.join());
    }

    buffer.writeln();
    buffer.writeln('Across:');
    for (final word
        in words.where((word) => word.direction == Direction.across).toList()
          ..sort(CrosswordWord.locationComparator)) {
      buffer.writeln('${word.location.prettyPrint()}: ${word.word}');
    }

    buffer.writeln();
    buffer.writeln('Down:');
    for (final word
        in words.where((word) => word.direction == Direction.down).toList()
          ..sort(CrosswordWord.locationComparator)) {
      buffer.writeln('${word.location.prettyPrint()}: ${word.word}');
    }

    return buffer.toString();
  }

  /// Constructor for [Crossword].
  factory Crossword.crossword({
    required int width,
    required int height,
    Iterable<CrosswordWord>? words,
  }) {
    return Crossword((b) {
      b
        ..width = width
        ..height = height;
      if (words != null) {
        b.words.addAll(words);
      }
    });
  }

  /// Constructor for [Crossword].
  /// Use [Crossword.crossword] instead.
  factory Crossword([void Function(CrosswordBuilder)? updates]) = _$Crossword;
  Crossword._();
}

/// A work queue for a worker to process. The work queue contains a crossword
/// and a list of locations to try, along with candidate words to add to the
/// crossword.
abstract class WorkQueue implements Built<WorkQueue, WorkQueueBuilder> {
  static Serializer<WorkQueue> get serializer => _$workQueueSerializer;

  /// The crossword the worker is working on.
  Crossword get crossword;

  /// The outstanding queue of locations to try, and the direction to try
  /// a word in at each location.
  BuiltMap<Location, Direction> get locationsToTry;

  /// Known bad locations.
  BuiltSet<Location> get badLocations;

  /// The list of unused candidate words that can be added to this crossword.
  BuiltSet<String> get candidateWords;

  /// Returns true if the work queue is complete.
  bool get isCompleted => locationsToTry.isEmpty || candidateWords.isEmpty;

  /// Create a work queue from a crossword.
  static WorkQueue from({
    required Crossword crossword,
    required Iterable<String> candidateWords,
    required Location startLocation,
  }) => WorkQueue((b) {
    if (crossword.words.isEmpty) {
      // Strip candidate words too long to fit in the crossword.
      b.candidateWords.addAll(
        candidateWords.where(
          (word) => word.characters.length <= crossword.width,
        ),
      );

      b.crossword.replace(crossword);

      b.locationsToTry.addAll({startLocation: Direction.across});
    } else {
      // Assume the crossword is partially populated.
      // Strip candidate words already in the crossword.
      final words = crossword.words.map((word) => word.word).toBuiltSet();
      b.candidateWords.addAll(
        candidateWords.where((word) => !words.contains(word)),
      );
      b.crossword.replace(crossword);

      // Eligible locations are characters that belong to a single word and
      // have no neighbour that would block a crossing word.
      crossword.characters
          .rebuild(
            (b) => b.removeWhere((location, character) {
              if (character.acrossWord != null && character.downWord != null) {
                return true;
              }
              final left = crossword.characters[location.left];
              if (left != null && left.downWord != null) return true;
              final right = crossword.characters[location.right];
              if (right != null && right.downWord != null) return true;
              final up = crossword.characters[location.up];
              if (up != null && up.acrossWord != null) return true;
              final down = crossword.characters[location.down];
              if (down != null && down.acrossWord != null) return true;
              return false;
            }),
          )
          .forEach((location, character) {
            b.locationsToTry.addAll({
              location: switch ((character.acrossWord, character.downWord)) {
                (null, null) => throw StateError(
                  'Character is not part of a word',
                ),
                (null, _) => Direction.across,
                (_, null) => Direction.down,
                (_, _) => throw StateError('Character is part of two words'),
              },
            });
          });
    }
  });

  /// Remove a location from the work queue, marking it as bad.
  WorkQueue remove(Location location) => rebuild(
    (b) => b
      ..locationsToTry.remove(location)
      ..badLocations.add(location),
  );

  /// Update the work queue from a crossword derived from the current crossword
  /// that this work queue is built from.
  WorkQueue updateFrom(Crossword crossword) =>
      WorkQueue.from(
        crossword: crossword,
        candidateWords: candidateWords,
        startLocation: locationsToTry.isNotEmpty
            ? locationsToTry.keys.first
            : Location.at(0, 0),
      ).rebuild(
        (b) => b
          ..badLocations.addAll(badLocations)
          ..locationsToTry.removeWhere(
            (location, _) => badLocations.contains(location),
          ),
      );

  /// Factory constructor for [WorkQueue].
  factory WorkQueue([void Function(WorkQueueBuilder)? updates]) = _$WorkQueue;

  WorkQueue._();
}

/// Display information for the current state of the crossword solve.
abstract class DisplayInfo implements Built<DisplayInfo, DisplayInfoBuilder> {
  static Serializer<DisplayInfo> get serializer => _$displayInfoSerializer;

  /// The number of words in the grid.
  String get wordsInGridCount;

  /// The number of candidate words.
  String get candidateWordsCount;

  /// The number of locations to explore.
  String get locationsToExploreCount;

  /// The number of known bad locations.
  String get knownBadLocationsCount;

  /// The percentage of the grid filled.
  String get gridFilledPercentage;

  /// Construct a [DisplayInfo] instance from a [WorkQueue].
  factory DisplayInfo.from({required WorkQueue workQueue}) {
    final gridFilled =
        workQueue.crossword.characters.length /
        (workQueue.crossword.width * workQueue.crossword.height);
    final fmt = NumberFormat.decimalPattern();

    return DisplayInfo(
      (b) => b
        ..wordsInGridCount = fmt.format(workQueue.crossword.words.length)
        ..candidateWordsCount = fmt.format(workQueue.candidateWords.length)
        ..locationsToExploreCount = fmt.format(workQueue.locationsToTry.length)
        ..knownBadLocationsCount = fmt.format(workQueue.badLocations.length)
        ..gridFilledPercentage = '${(gridFilled * 100).toStringAsFixed(2)}%',
    );
  }

  /// An empty [DisplayInfo] instance.
  static DisplayInfo get empty => DisplayInfo(
    (b) => b
      ..wordsInGridCount = '0'
      ..candidateWordsCount = '0'
      ..locationsToExploreCount = '0'
      ..knownBadLocationsCount = '0'
      ..gridFilledPercentage = '0%',
  );

  factory DisplayInfo([void Function(DisplayInfoBuilder)? updates]) =
      _$DisplayInfo;
  DisplayInfo._();
}

/// A crossword puzzle game. The player picks, for each word slot in the
/// [crossword], the right word from a list that mixes it with
/// [alternateWords] of the same length.
abstract class CrosswordPuzzleGame
    implements Built<CrosswordPuzzleGame, CrosswordPuzzleGameBuilder> {
  static Serializer<CrosswordPuzzleGame> get serializer =>
      _$crosswordPuzzleGameSerializer;

  /// The crossword for this puzzle.
  Crossword get crossword;

  /// The alternate words for each [CrosswordWord] in the crossword, keyed by
  /// the word's location and direction.
  BuiltMap<Location, BuiltMap<Direction, BuiltList<String>>> get alternateWords;

  /// The player's selected words.
  BuiltList<CrosswordWord> get selectedWords;

  /// Whether [word] can be selected for the slot at [location] in
  /// [direction]: its letters must agree with every other selected word it
  /// crosses. A word already selected in that slot is replaced.
  bool canSelectWord({
    required Location location,
    required String word,
    required Direction direction,
  }) {
    final crosswordWord = CrosswordWord.word(
      word: word,
      location: location,
      direction: direction,
    );
    if (selectedWords.contains(crosswordWord)) {
      return true;
    }

    final otherWords = Crossword.crossword(
      width: crossword.width,
      height: crossword.height,
      words: selectedWords.where(
        (selected) =>
            !(selected.location == location &&
                selected.direction == direction),
      ),
    );

    for (final (index, character) in word.characters.indexed) {
      final characterLocation = switch (direction) {
        Direction.across => location.rightOffset(index),
        Direction.down => location.downOffset(index),
      };
      final existing = otherWords.characters[characterLocation];
      if (existing != null && existing.character != character) {
        return false;
      }
    }
    return true;
  }

  /// Select [word] for the slot at [location] in [direction], replacing any
  /// word already selected there. Selecting the currently selected word
  /// deselects it. Returns null if the word can't be selected.
  CrosswordPuzzleGame? selectWord({
    required Location location,
    required String word,
    required Direction direction,
  }) {
    final crosswordWord = CrosswordWord.word(
      word: word,
      location: location,
      direction: direction,
    );

    if (selectedWords.contains(crosswordWord)) {
      return rebuild((b) => b.selectedWords.remove(crosswordWord));
    }

    if (!canSelectWord(location: location, word: word, direction: direction)) {
      return null;
    }

    return rebuild(
      (b) => b.selectedWords
        ..removeWhere(
          (selected) =>
              selected.location == location && selected.direction == direction,
        )
        ..add(crosswordWord),
    );
  }

  /// A crossword built from the player's selected words, for display.
  @memoized
  Crossword get crosswordFromSelectedWords => Crossword.crossword(
    width: crossword.width,
    height: crossword.height,
    words: selectedWords,
  );

  /// Whether the player has selected the correct word for every slot.
  bool get solved =>
      crossword.words.isNotEmpty &&
      selectedWords.toBuiltSet() == crossword.words.toBuiltSet();

  /// Create a puzzle from [crossword], picking up to 4 alternate words of the
  /// same length from [candidateWords] for each word in the crossword.
  factory CrosswordPuzzleGame.from({
    required Crossword crossword,
    required BuiltSet<String> candidateWords,
  }) {
    final usedWords = crossword.words.map((word) => word.word).toSet();

    // Group the unused candidates by length so alternates can be picked
    // without scanning the whole word list for every crossword word.
    final candidatesByLength = <int, List<String>>{};
    for (final word in candidateWords) {
      if (usedWords.contains(word)) continue;
      candidatesByLength.putIfAbsent(word.length, () => []).add(word);
    }
    for (final words in candidatesByLength.values) {
      words.shuffle();
    }

    final alternates =
        <Location, Map<Direction, BuiltList<String>>>{};
    for (final crosswordWord in crossword.words) {
      final pool = candidatesByLength[crosswordWord.word.length] ?? [];
      final picked = pool.take(4).toList()..sort();
      // Don't reuse the same alternates for another word.
      pool.removeRange(0, picked.length);

      alternates.putIfAbsent(crosswordWord.location, () => {})[crosswordWord
              .direction] =
          picked.toBuiltList();
    }

    return CrosswordPuzzleGame(
      (b) => b
        ..crossword.replace(crossword)
        ..alternateWords.replace(
          alternates.map(
            (location, byDirection) =>
                MapEntry(location, byDirection.build()),
          ),
        ),
    );
  }

  factory CrosswordPuzzleGame([
    void Function(CrosswordPuzzleGameBuilder)? updates,
  ]) = _$CrosswordPuzzleGame;
  CrosswordPuzzleGame._();
}

/// Construct the serialization/deserialization code for the data model.
@SerializersFor([
  Location,
  Crossword,
  CrosswordWord,
  CrosswordCharacter,
  WorkQueue,
  DisplayInfo,
  CrosswordPuzzleGame,
])
final Serializers serializers = _$serializers;
