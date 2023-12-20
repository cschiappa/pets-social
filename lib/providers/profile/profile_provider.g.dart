// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authMethodsHash() => r'a0dfdb99538f56e08bdb8421ee03e4d869c7fe9e';

/// See also [authMethods].
@ProviderFor(authMethods)
final authMethodsProvider = Provider<AuthMethods>.internal(
  authMethods,
  name: r'authMethodsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authMethodsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthMethodsRef = ProviderRef<AuthMethods>;
String _$getBlockedProfilesHash() =>
    r'b9c6b1c75ac5a977d3b00bb54b46df8a186587cd';

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

/// See also [getBlockedProfiles].
@ProviderFor(getBlockedProfiles)
const getBlockedProfilesProvider = GetBlockedProfilesFamily();

/// See also [getBlockedProfiles].
class GetBlockedProfilesFamily
    extends Family<AsyncValue<QuerySnapshot<Map<String, dynamic>>>> {
  /// See also [getBlockedProfiles].
  const GetBlockedProfilesFamily();

  /// See also [getBlockedProfiles].
  GetBlockedProfilesProvider call(
    List<dynamic>? blockedProfiles,
  ) {
    return GetBlockedProfilesProvider(
      blockedProfiles,
    );
  }

  @override
  GetBlockedProfilesProvider getProviderOverride(
    covariant GetBlockedProfilesProvider provider,
  ) {
    return call(
      provider.blockedProfiles,
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
  String? get name => r'getBlockedProfilesProvider';
}

/// See also [getBlockedProfiles].
class GetBlockedProfilesProvider
    extends AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>> {
  /// See also [getBlockedProfiles].
  GetBlockedProfilesProvider(
    List<dynamic>? blockedProfiles,
  ) : this._internal(
          (ref) => getBlockedProfiles(
            ref as GetBlockedProfilesRef,
            blockedProfiles,
          ),
          from: getBlockedProfilesProvider,
          name: r'getBlockedProfilesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBlockedProfilesHash,
          dependencies: GetBlockedProfilesFamily._dependencies,
          allTransitiveDependencies:
              GetBlockedProfilesFamily._allTransitiveDependencies,
          blockedProfiles: blockedProfiles,
        );

  GetBlockedProfilesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.blockedProfiles,
  }) : super.internal();

  final List<dynamic>? blockedProfiles;

  @override
  Override overrideWith(
    Stream<QuerySnapshot<Map<String, dynamic>>> Function(
            GetBlockedProfilesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBlockedProfilesProvider._internal(
        (ref) => create(ref as GetBlockedProfilesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        blockedProfiles: blockedProfiles,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<QuerySnapshot<Map<String, dynamic>>>
      createElement() {
    return _GetBlockedProfilesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBlockedProfilesProvider &&
        other.blockedProfiles == blockedProfiles;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, blockedProfiles.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetBlockedProfilesRef
    on AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>> {
  /// The parameter `blockedProfiles` of this provider.
  List<dynamic>? get blockedProfiles;
}

class _GetBlockedProfilesProviderElement
    extends AutoDisposeStreamProviderElement<
        QuerySnapshot<Map<String, dynamic>>> with GetBlockedProfilesRef {
  _GetBlockedProfilesProviderElement(super.provider);

  @override
  List<dynamic>? get blockedProfiles =>
      (origin as GetBlockedProfilesProvider).blockedProfiles;
}

String _$getAccountProfilesHash() =>
    r'be666e77e3744a1faf920f96b811e1284534bfc6';

/// See also [getAccountProfiles].
@ProviderFor(getAccountProfiles)
final getAccountProfilesProvider =
    AutoDisposeStreamProvider<QuerySnapshot<Map<String, dynamic>>>.internal(
  getAccountProfiles,
  name: r'getAccountProfilesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAccountProfilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAccountProfilesRef
    = AutoDisposeStreamProviderRef<QuerySnapshot<Map<String, dynamic>>>;
String _$getProfilesWhereHash() => r'e30c91ccb32f63560360c0d0e6e39741822b1594';

/// See also [getProfilesWhere].
@ProviderFor(getProfilesWhere)
const getProfilesWhereProvider = GetProfilesWhereFamily();

/// See also [getProfilesWhere].
class GetProfilesWhereFamily extends Family<AsyncValue<List<ModelProfile>>> {
  /// See also [getProfilesWhere].
  const GetProfilesWhereFamily();

  /// See also [getProfilesWhere].
  GetProfilesWhereProvider call(
    String profileUid,
  ) {
    return GetProfilesWhereProvider(
      profileUid,
    );
  }

  @override
  GetProfilesWhereProvider getProviderOverride(
    covariant GetProfilesWhereProvider provider,
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
  String? get name => r'getProfilesWhereProvider';
}

/// See also [getProfilesWhere].
class GetProfilesWhereProvider
    extends AutoDisposeFutureProvider<List<ModelProfile>> {
  /// See also [getProfilesWhere].
  GetProfilesWhereProvider(
    String profileUid,
  ) : this._internal(
          (ref) => getProfilesWhere(
            ref as GetProfilesWhereRef,
            profileUid,
          ),
          from: getProfilesWhereProvider,
          name: r'getProfilesWhereProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfilesWhereHash,
          dependencies: GetProfilesWhereFamily._dependencies,
          allTransitiveDependencies:
              GetProfilesWhereFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetProfilesWhereProvider._internal(
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
    FutureOr<List<ModelProfile>> Function(GetProfilesWhereRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfilesWhereProvider._internal(
        (ref) => create(ref as GetProfilesWhereRef),
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
  AutoDisposeFutureProviderElement<List<ModelProfile>> createElement() {
    return _GetProfilesWhereProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfilesWhereProvider && other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfilesWhereRef on AutoDisposeFutureProviderRef<List<ModelProfile>> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;
}

class _GetProfilesWhereProviderElement
    extends AutoDisposeFutureProviderElement<List<ModelProfile>>
    with GetProfilesWhereRef {
  _GetProfilesWhereProviderElement(super.provider);

  @override
  String get profileUid => (origin as GetProfilesWhereProvider).profileUid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
