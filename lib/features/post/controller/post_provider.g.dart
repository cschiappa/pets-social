// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postRepositoryHash() => r'4bbd5074119f8c0acb16127ee14e58cf3add80ff';

/// See also [postRepository].
@ProviderFor(postRepository)
final postRepositoryProvider = Provider<PostRepository>.internal(
  postRepository,
  name: r'postRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PostRepositoryRef = ProviderRef<PostRepository>;
String _$getPostsDescendingHash() =>
    r'ebaf2d223c457c5e5d0ad1d595de776e83d04452';

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

/// See also [getPostsDescending].
@ProviderFor(getPostsDescending)
const getPostsDescendingProvider = GetPostsDescendingFamily();

/// See also [getPostsDescending].
class GetPostsDescendingFamily extends Family<AsyncValue<List<ModelPost>>> {
  /// See also [getPostsDescending].
  const GetPostsDescendingFamily();

  /// See also [getPostsDescending].
  GetPostsDescendingProvider call(
    ModelProfile profile,
  ) {
    return GetPostsDescendingProvider(
      profile,
    );
  }

  @override
  GetPostsDescendingProvider getProviderOverride(
    covariant GetPostsDescendingProvider provider,
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
  String? get name => r'getPostsDescendingProvider';
}

/// See also [getPostsDescending].
class GetPostsDescendingProvider
    extends AutoDisposeFutureProvider<List<ModelPost>> {
  /// See also [getPostsDescending].
  GetPostsDescendingProvider(
    ModelProfile profile,
  ) : this._internal(
          (ref) => getPostsDescending(
            ref as GetPostsDescendingRef,
            profile,
          ),
          from: getPostsDescendingProvider,
          name: r'getPostsDescendingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPostsDescendingHash,
          dependencies: GetPostsDescendingFamily._dependencies,
          allTransitiveDependencies:
              GetPostsDescendingFamily._allTransitiveDependencies,
          profile: profile,
        );

  GetPostsDescendingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profile,
  }) : super.internal();

  final ModelProfile profile;

  @override
  Override overrideWith(
    FutureOr<List<ModelPost>> Function(GetPostsDescendingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetPostsDescendingProvider._internal(
        (ref) => create(ref as GetPostsDescendingRef),
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
  AutoDisposeFutureProviderElement<List<ModelPost>> createElement() {
    return _GetPostsDescendingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetPostsDescendingProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetPostsDescendingRef on AutoDisposeFutureProviderRef<List<ModelPost>> {
  /// The parameter `profile` of this provider.
  ModelProfile get profile;
}

class _GetPostsDescendingProviderElement
    extends AutoDisposeFutureProviderElement<List<ModelPost>>
    with GetPostsDescendingRef {
  _GetPostsDescendingProviderElement(super.provider);

  @override
  ModelProfile get profile => (origin as GetPostsDescendingProvider).profile;
}

String _$getFeedPostsHash() => r'c5002a5c60e4513acaf641a0d4bc7140a6fe8cd6';

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

String _$getSavedPostsHash() => r'1fb635cd08a64c39ba4b3b60d4f7bcbcff7e2045';

/// See also [getSavedPosts].
@ProviderFor(getSavedPosts)
const getSavedPostsProvider = GetSavedPostsFamily();

/// See also [getSavedPosts].
class GetSavedPostsFamily extends Family<AsyncValue<List<ModelPost>>> {
  /// See also [getSavedPosts].
  const GetSavedPostsFamily();

  /// See also [getSavedPosts].
  GetSavedPostsProvider call(
    List<dynamic> savedPosts,
  ) {
    return GetSavedPostsProvider(
      savedPosts,
    );
  }

  @override
  GetSavedPostsProvider getProviderOverride(
    covariant GetSavedPostsProvider provider,
  ) {
    return call(
      provider.savedPosts,
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
  String? get name => r'getSavedPostsProvider';
}

/// See also [getSavedPosts].
class GetSavedPostsProvider extends AutoDisposeFutureProvider<List<ModelPost>> {
  /// See also [getSavedPosts].
  GetSavedPostsProvider(
    List<dynamic> savedPosts,
  ) : this._internal(
          (ref) => getSavedPosts(
            ref as GetSavedPostsRef,
            savedPosts,
          ),
          from: getSavedPostsProvider,
          name: r'getSavedPostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getSavedPostsHash,
          dependencies: GetSavedPostsFamily._dependencies,
          allTransitiveDependencies:
              GetSavedPostsFamily._allTransitiveDependencies,
          savedPosts: savedPosts,
        );

  GetSavedPostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.savedPosts,
  }) : super.internal();

  final List<dynamic> savedPosts;

  @override
  Override overrideWith(
    FutureOr<List<ModelPost>> Function(GetSavedPostsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetSavedPostsProvider._internal(
        (ref) => create(ref as GetSavedPostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        savedPosts: savedPosts,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ModelPost>> createElement() {
    return _GetSavedPostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetSavedPostsProvider && other.savedPosts == savedPosts;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, savedPosts.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetSavedPostsRef on AutoDisposeFutureProviderRef<List<ModelPost>> {
  /// The parameter `savedPosts` of this provider.
  List<dynamic> get savedPosts;
}

class _GetSavedPostsProviderElement
    extends AutoDisposeFutureProviderElement<List<ModelPost>>
    with GetSavedPostsRef {
  _GetSavedPostsProviderElement(super.provider);

  @override
  List<dynamic> get savedPosts => (origin as GetSavedPostsProvider).savedPosts;
}

String _$getCommentsHash() => r'd81ebf80e709b0a979331a07bb6e9af6c1cb2a9b';

/// See also [getComments].
@ProviderFor(getComments)
const getCommentsProvider = GetCommentsFamily();

/// See also [getComments].
class GetCommentsFamily
    extends Family<AsyncValue<QuerySnapshot<Map<String, dynamic>>>> {
  /// See also [getComments].
  const GetCommentsFamily();

  /// See also [getComments].
  GetCommentsProvider call(
    String postId,
  ) {
    return GetCommentsProvider(
      postId,
    );
  }

  @override
  GetCommentsProvider getProviderOverride(
    covariant GetCommentsProvider provider,
  ) {
    return call(
      provider.postId,
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
  String? get name => r'getCommentsProvider';
}

/// See also [getComments].
class GetCommentsProvider
    extends AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> {
  /// See also [getComments].
  GetCommentsProvider(
    String postId,
  ) : this._internal(
          (ref) => getComments(
            ref as GetCommentsRef,
            postId,
          ),
          from: getCommentsProvider,
          name: r'getCommentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getCommentsHash,
          dependencies: GetCommentsFamily._dependencies,
          allTransitiveDependencies:
              GetCommentsFamily._allTransitiveDependencies,
          postId: postId,
        );

  GetCommentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    Stream<QuerySnapshot<Map<String, dynamic>>> Function(
            GetCommentsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetCommentsProvider._internal(
        (ref) => create(ref as GetCommentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<QuerySnapshot<Map<String, dynamic>>>
      createElement() {
    return _GetCommentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCommentsProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetCommentsRef
    on AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _GetCommentsProviderElement extends AutoDisposeStreamProviderElement<
    QuerySnapshot<Map<String, dynamic>>> with GetCommentsRef {
  _GetCommentsProviderElement(super.provider);

  @override
  String get postId => (origin as GetCommentsProvider).postId;
}

String _$getProfilePostsHash() => r'9a64973b1d64b402ec369074ada9b62e6c5abe4a';

/// See also [getProfilePosts].
@ProviderFor(getProfilePosts)
const getProfilePostsProvider = GetProfilePostsFamily();

/// See also [getProfilePosts].
class GetProfilePostsFamily
    extends Family<AsyncValue<QuerySnapshot<Map<String, dynamic>>>> {
  /// See also [getProfilePosts].
  const GetProfilePostsFamily();

  /// See also [getProfilePosts].
  GetProfilePostsProvider call(
    String profileUid,
  ) {
    return GetProfilePostsProvider(
      profileUid,
    );
  }

  @override
  GetProfilePostsProvider getProviderOverride(
    covariant GetProfilePostsProvider provider,
  ) {
    return call(
      provider.profileUid,
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
  String? get name => r'getProfilePostsProvider';
}

/// See also [getProfilePosts].
class GetProfilePostsProvider
    extends AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> {
  /// See also [getProfilePosts].
  GetProfilePostsProvider(
    String profileUid,
  ) : this._internal(
          (ref) => getProfilePosts(
            ref as GetProfilePostsRef,
            profileUid,
          ),
          from: getProfilePostsProvider,
          name: r'getProfilePostsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfilePostsHash,
          dependencies: GetProfilePostsFamily._dependencies,
          allTransitiveDependencies:
              GetProfilePostsFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetProfilePostsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileUid,
  }) : super.internal();

  final String profileUid;

  @override
  Override overrideWith(
    Stream<QuerySnapshot<Map<String, dynamic>>> Function(
            GetProfilePostsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfilePostsProvider._internal(
        (ref) => create(ref as GetProfilePostsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileUid: profileUid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<QuerySnapshot<Map<String, dynamic>>>
      createElement() {
    return _GetProfilePostsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfilePostsProvider && other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfilePostsRef
    on AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;
}

class _GetProfilePostsProviderElement extends AutoDisposeStreamProviderElement<
    QuerySnapshot<Map<String, dynamic>>> with GetProfilePostsRef {
  _GetProfilePostsProviderElement(super.provider);

  @override
  String get profileUid => (origin as GetProfilePostsProvider).profileUid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
