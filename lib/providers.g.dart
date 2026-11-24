// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A provider for the wordlist to use when generating the crossword.

@ProviderFor(wordList)
final wordListProvider = WordListProvider._();

/// A provider for the wordlist to use when generating the crossword.

final class WordListProvider
    extends
        $FunctionalProvider<
          AsyncValue<BuiltSet<String>>,
          BuiltSet<String>,
          FutureOr<BuiltSet<String>>
        >
    with $FutureModifier<BuiltSet<String>>, $FutureProvider<BuiltSet<String>> {
  /// A provider for the wordlist to use when generating the crossword.
  WordListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordListHash();

  @$internal
  @override
  $FutureProviderElement<BuiltSet<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BuiltSet<String>> create(Ref ref) {
    return wordList(ref);
  }
}

String _$wordListHash() => r'07003444d7241448561b638500001e31610b4717';

/// A provider that holds the current size of the crossword to generate.

@ProviderFor(Size)
final sizeProvider = SizeProvider._();

/// A provider that holds the current size of the crossword to generate.
final class SizeProvider extends $NotifierProvider<Size, CrosswordSize> {
  /// A provider that holds the current size of the crossword to generate.
  SizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sizeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sizeHash();

  @$internal
  @override
  Size create() => Size();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrosswordSize value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrosswordSize>(value),
    );
  }
}

String _$sizeHash() => r'689ac2961f81a3c3e3728d765c8b68c961b5d398';

/// A provider that holds the current size of the crossword to generate.

abstract class _$Size extends $Notifier<CrosswordSize> {
  CrosswordSize build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CrosswordSize, CrosswordSize>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CrosswordSize, CrosswordSize>,
              CrosswordSize,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// A provider that generates a crossword in background isolates, streaming
/// the [model.WorkQueue] state on each step of the search.

@ProviderFor(workQueue)
final workQueueProvider = WorkQueueProvider._();

/// A provider that generates a crossword in background isolates, streaming
/// the [model.WorkQueue] state on each step of the search.

final class WorkQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<model.WorkQueue>,
          model.WorkQueue,
          Stream<model.WorkQueue>
        >
    with $FutureModifier<model.WorkQueue>, $StreamProvider<model.WorkQueue> {
  /// A provider that generates a crossword in background isolates, streaming
  /// the [model.WorkQueue] state on each step of the search.
  WorkQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workQueueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workQueueHash();

  @$internal
  @override
  $StreamProviderElement<model.WorkQueue> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<model.WorkQueue> create(Ref ref) {
    return workQueue(ref);
  }
}

String _$workQueueHash() => r'2408d6f47509fdd1515e733b4c93cf5f1c19f8a7';

/// The puzzle the player is solving. Starts empty, and is built from the
/// generated crossword once generation completes.

@ProviderFor(Puzzle)
final puzzleProvider = PuzzleProvider._();

/// The puzzle the player is solving. Starts empty, and is built from the
/// generated crossword once generation completes.
final class PuzzleProvider
    extends $NotifierProvider<Puzzle, model.CrosswordPuzzleGame> {
  /// The puzzle the player is solving. Starts empty, and is built from the
  /// generated crossword once generation completes.
  PuzzleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'puzzleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$puzzleHash();

  @$internal
  @override
  Puzzle create() => Puzzle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(model.CrosswordPuzzleGame value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<model.CrosswordPuzzleGame>(value),
    );
  }
}

String _$puzzleHash() => r'e3cc968b00acda85d8a1dd960b6069d97aef3bc5';

/// The puzzle the player is solving. Starts empty, and is built from the
/// generated crossword once generation completes.

abstract class _$Puzzle extends $Notifier<model.CrosswordPuzzleGame> {
  model.CrosswordPuzzleGame build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<model.CrosswordPuzzleGame, model.CrosswordPuzzleGame>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<model.CrosswordPuzzleGame, model.CrosswordPuzzleGame>,
              model.CrosswordPuzzleGame,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
