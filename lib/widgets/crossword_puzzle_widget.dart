import 'package:built_collection/built_collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../model.dart';
import '../providers.dart';

/// The playable puzzle. Tapping a cell opens a menu to pick the across
/// and/or down word that passes through it.
class CrosswordPuzzleWidget extends ConsumerWidget {
  const CrosswordPuzzleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = ref.watch(sizeProvider);
    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      cellBuilder: _buildCell,
      columnCount: size.width,
      columnBuilder: (index) => _buildSpan(context, index),
      rowCount: size.height,
      rowBuilder: (index) => _buildSpan(context, index),
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    final location = Location.at(vicinity.column, vicinity.row);

    return TableViewCell(
      child: Consumer(
        builder: (context, ref, _) {
          final character = ref.watch(
            puzzleProvider.select(
              (puzzle) => puzzle.crossword.characters[location],
            ),
          );
          final selectedCharacter = ref.watch(
            puzzleProvider.select(
              (puzzle) =>
                  puzzle.crosswordFromSelectedWords.characters[location],
            ),
          );
          final alternateWords = ref.watch(
            puzzleProvider.select((puzzle) => puzzle.alternateWords),
          );

          if (character == null) {
            return ColoredBox(
              color: Theme.of(context).colorScheme.primaryContainer,
            );
          }

          // The options for each slot: the real word plus its alternates.
          final acrossWord = character.acrossWord;
          final acrossWords = acrossWord == null
              ? BuiltList<String>()
              : BuiltList<String>([
                  acrossWord.word,
                  ...?alternateWords[acrossWord.location]?[Direction.across],
                ]).rebuild((b) => b.sort());

          final downWord = character.downWord;
          final downWords = downWord == null
              ? BuiltList<String>()
              : BuiltList<String>([
                  downWord.word,
                  ...?alternateWords[downWord.location]?[Direction.down],
                ]).rebuild((b) => b.sort());

          return MenuAnchor(
            builder: (context, controller, _) {
              return GestureDetector(
                onTapDown: (details) =>
                    controller.open(position: details.localPosition),
                child: AnimatedContainer(
                  duration: Durations.extralong1,
                  curve: Curves.easeInOut,
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Durations.extralong1,
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text(selectedCharacter?.character ?? ''),
                    ),
                  ),
                ),
              );
            },
            menuChildren: [
              if (acrossWords.isNotEmpty && downWords.isNotEmpty)
                Padding(padding: const EdgeInsets.all(4), child: Text('Across')),
              for (final word in acrossWords)
                _WordSelectMenuItem(
                  location: acrossWord!.location,
                  word: word,
                  selectedCharacter: selectedCharacter,
                  direction: Direction.across,
                ),
              if (acrossWords.isNotEmpty && downWords.isNotEmpty)
                Padding(padding: const EdgeInsets.all(4), child: Text('Down')),
              for (final word in downWords)
                _WordSelectMenuItem(
                  location: downWord!.location,
                  word: word,
                  selectedCharacter: selectedCharacter,
                  direction: Direction.down,
                ),
            ],
          );
        },
      ),
    );
  }

  TableSpan _buildSpan(BuildContext context, int index) {
    return TableSpan(
      extent: FixedTableSpanExtent(32),
      foregroundDecoration: TableSpanDecoration(
        border: TableSpanBorder(
          leading: BorderSide(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          trailing: BorderSide(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

/// A menu entry for one candidate word. Disabled when it conflicts with a
/// crossing word the player already selected.
class _WordSelectMenuItem extends ConsumerWidget {
  const _WordSelectMenuItem({
    required this.location,
    required this.word,
    required this.selectedCharacter,
    required this.direction,
  });

  final Location location;
  final String word;
  final CrosswordCharacter? selectedCharacter;
  final Direction direction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(puzzleProvider.notifier);
    final canSelect = ref.watch(
      puzzleProvider.select(
        (puzzle) => puzzle.canSelectWord(
          location: location,
          word: word,
          direction: direction,
        ),
      ),
    );
    final selected = switch (direction) {
      Direction.across => selectedCharacter?.acrossWord?.word == word,
      Direction.down => selectedCharacter?.downWord?.word == word,
    };

    return MenuItemButton(
      onPressed: canSelect
          ? () => notifier.selectWord(
              location: location,
              word: word,
              direction: direction,
            )
          : null,
      leadingIcon: selected
          ? Icon(Icons.radio_button_checked_outlined)
          : Icon(Icons.radio_button_unchecked_outlined),
      child: Text(word),
    );
  }
}
