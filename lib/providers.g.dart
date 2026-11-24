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

/// A provider that generates a crossword in a background isolate, streaming
/// the [model.WorkQueue] state on each step of the search.

@ProviderFor(workQueue)
final workQueueProvider = WorkQueueProvider._();

/// A provider that generates a crossword in a background isolate, streaming
/// the [model.WorkQueue] state on each step of the search.

final class WorkQueueProvider
    extends
        $FunctionalProvider<
          AsyncValue<model.WorkQueue>,
          model.WorkQueue,
          Stream<model.WorkQueue>
        >
    with $FutureModifier<model.WorkQueue>, $StreamProvider<model.WorkQueue> {
  /// A provider that generates a crossword in a background isolate, streaming
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

String _$workQueueHash() => r'3e484a5afe91003b1523ffb42caa6b24967376a6';

/// The time the current crossword generation started.

@ProviderFor(StartTime)
final startTimeProvider = StartTimeProvider._();

/// The time the current crossword generation started.
final class StartTimeProvider extends $NotifierProvider<StartTime, DateTime?> {
  /// The time the current crossword generation started.
  StartTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startTimeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startTimeHash();

  @$internal
  @override
  StartTime create() => StartTime();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$startTimeHash() => r'213692f63fec8e8a17b12c6946e8c62983d7818b';

/// The time the current crossword generation started.

abstract class _$StartTime extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The time the current crossword generation ended, or null while running.

@ProviderFor(EndTime)
final endTimeProvider = EndTimeProvider._();

/// The time the current crossword generation ended, or null while running.
final class EndTimeProvider extends $NotifierProvider<EndTime, DateTime?> {
  /// The time the current crossword generation ended, or null while running.
  EndTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endTimeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endTimeHash();

  @$internal
  @override
  EndTime create() => EndTime();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime?>(value),
    );
  }
}

String _$endTimeHash() => r'ae42bbb0a46ace7da0f1f3715b71143c1d759d1f';

/// The time the current crossword generation ended, or null while running.

abstract class _$EndTime extends $Notifier<DateTime?> {
  DateTime? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DateTime?, DateTime?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime?, DateTime?>,
              DateTime?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// An estimate of the time remaining until crossword generation completes.

@ProviderFor(expectedRemainingTime)
final expectedRemainingTimeProvider = ExpectedRemainingTimeProvider._();

/// An estimate of the time remaining until crossword generation completes.

final class ExpectedRemainingTimeProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  /// An estimate of the time remaining until crossword generation completes.
  ExpectedRemainingTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expectedRemainingTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expectedRemainingTimeHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return expectedRemainingTime(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$expectedRemainingTimeHash() =>
    r'45f19e0d3e281c34cb54ed7f67cc783ec5073889';

/// Whether to show the crossword generation info overlay.

@ProviderFor(ShowDisplayInfo)
final showDisplayInfoProvider = ShowDisplayInfoProvider._();

/// Whether to show the crossword generation info overlay.
final class ShowDisplayInfoProvider
    extends $NotifierProvider<ShowDisplayInfo, bool> {
  /// Whether to show the crossword generation info overlay.
  ShowDisplayInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showDisplayInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showDisplayInfoHash();

  @$internal
  @override
  ShowDisplayInfo create() => ShowDisplayInfo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showDisplayInfoHash() => r'2d1022c4613de81e6d5f0c2d9405cb50296d13d1';

/// Whether to show the crossword generation info overlay.

abstract class _$ShowDisplayInfo extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Display information about the current state of crossword generation.

@ProviderFor(DisplayInfo)
final displayInfoProvider = DisplayInfoProvider._();

/// Display information about the current state of crossword generation.
final class DisplayInfoProvider
    extends $NotifierProvider<DisplayInfo, model.DisplayInfo> {
  /// Display information about the current state of crossword generation.
  DisplayInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'displayInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$displayInfoHash();

  @$internal
  @override
  DisplayInfo create() => DisplayInfo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(model.DisplayInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<model.DisplayInfo>(value),
    );
  }
}

String _$displayInfoHash() => r'42483707461b81e1dbafee1647cd45225dee2cc3';

/// Display information about the current state of crossword generation.

abstract class _$DisplayInfo extends $Notifier<model.DisplayInfo> {
  model.DisplayInfo build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<model.DisplayInfo, model.DisplayInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<model.DisplayInfo, model.DisplayInfo>,
              model.DisplayInfo,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
