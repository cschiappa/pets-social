// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firestoreHash() => r'57e293dfe68924f9198a814ea13ec56cce956c7b';

/// See also [firestore].
@ProviderFor(firestore)
final firestoreProvider = Provider<FirestoreMethods>.internal(
  firestore,
  name: r'firestoreProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirestoreRef = ProviderRef<FirestoreMethods>;
String _$getPostsDescendingHash() =>
    r'fcb19f6adef77e21ff7cbea27618a05ed90e4b87';

/// See also [getPostsDescending].
@ProviderFor(getPostsDescending)
final getPostsDescendingProvider =
    AutoDisposeFutureProvider<List<ModelPost>>.internal(
  getPostsDescending,
  name: r'getPostsDescendingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPostsDescendingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetPostsDescendingRef = AutoDisposeFutureProviderRef<List<ModelPost>>;
String _$getFeedPostsHash() => r'910b718fe352d2cff0bfab5d79eb29602fc8f036';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getFeedPosts].
@ProviderFor(getFeedPosts)
const getFeedPostsProvider = GetFeedPostsFamily();

/// See also [getFeedPosts].
class GetFeedPostsFamily extends Family<AsyncValue<List<DocumentSnapshot>>> {
  /// See also [getFeedPosts].
  const GetFeedPostsFamily();

  /// See also [getFeedPosts].
  GetFeedPostsProvider call(
    ModelProfile? profile,
  ) {
    return GetFeedPostsProvider(
      profile,
    );
  }

  @override
  GetFeedPostsProvider getProviderOverride(
    covariant GetFeedPostsProvider provider,
  ) {
    return call(
      provider.profile,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getFeedPostsProvider';
}

/// See also [getFeedPosts].
class GetFeedPostsProvider
    extends AutoDisposeStreamProvider<List<DocumentSnapshot>> {
  /// See also [getFeedPosts].
  GetFeedPostsProvider(
    ModelProfile? profile,
  ) : this._internal(
          (ref) => getFeedPosts(
            ref as GetFeedPostsRef,
            profile,
          ),
          from: getFeedPostsProvider,
          name: r'getFeedPostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFeedPostsHash,
          dependencies: GetFeedPostsFamily._dependencies,
          allTransitiveDependencies:
              GetFeedPostsFamily._allTransitiveDependencies,
          profile: profile,
        );

  GetFeedPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profile,
  }) : super.internal();

  final ModelProfile? profile;

  @override
  Override overrideWith(
    Stream<List<DocumentSnapshot>> Function(GetFeedPostsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFeedPostsProvider._internal(
        (ref) => create(ref as GetFeedPostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profile: profile,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<DocumentSnapshot>> createElement() {
    return _GetFeedPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFeedPostsProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetFeedPostsRef on AutoDisposeStreamProviderRef<List<DocumentSnapshot>> {
  /// The parameter `profile` of this provider.
  ModelProfile? get profile;
}

class _GetFeedPostsProviderElement
    extends AutoDisposeStreamProviderElement<List<DocumentSnapshot>>
    with GetFeedPostsRef {
  _GetFeedPostsProviderElement(super.provider);

  @override
  ModelProfile? get profile => (origin as GetFeedPostsProvider).profile;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
