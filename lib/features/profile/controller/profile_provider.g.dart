// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileRepositoryHash() => r'280e9d77aec88e38cf462ad0d6d94f9744700822';

/// See also [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider = Provider<ProfileRepository>.internal(
  profileRepository,
  name: r'profileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileRepositoryRef = ProviderRef<ProfileRepository>;
String _$getProfileDataHash() => r'a0a5d6aedd91a2d37e32f45570a973aab433bd01';

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

/// See also [getProfileData].
@ProviderFor(getProfileData)
const getProfileDataProvider = GetProfileDataFamily();

/// See also [getProfileData].
class GetProfileDataFamily extends Family<AsyncValue<ModelProfile>> {
  /// See also [getProfileData].
  const GetProfileDataFamily();

  /// See also [getProfileData].
  GetProfileDataProvider call(
    String? profileUid,
  ) {
    return GetProfileDataProvider(
      profileUid,
    );
  }

  @override
  GetProfileDataProvider getProviderOverride(
    covariant GetProfileDataProvider provider,
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
  String? get name => r'getProfileDataProvider';
}

/// See also [getProfileData].
class GetProfileDataProvider extends AutoDisposeStreamProvider<ModelProfile> {
  /// See also [getProfileData].
  GetProfileDataProvider(
    String? profileUid,
  ) : this._internal(
          (ref) => getProfileData(
            ref as GetProfileDataRef,
            profileUid,
          ),
          from: getProfileDataProvider,
          name: r'getProfileDataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfileDataHash,
          dependencies: GetProfileDataFamily._dependencies,
          allTransitiveDependencies:
              GetProfileDataFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetProfileDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileUid,
  }) : super.internal();

  final String? profileUid;

  @override
  Override overrideWith(
    Stream<ModelProfile> Function(GetProfileDataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfileDataProvider._internal(
        (ref) => create(ref as GetProfileDataRef),
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
  AutoDisposeStreamProviderElement<ModelProfile> createElement() {
    return _GetProfileDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfileDataProvider && other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfileDataRef on AutoDisposeStreamProviderRef<ModelProfile> {
  /// The parameter `profileUid` of this provider.
  String? get profileUid;
}

class _GetProfileDataProviderElement
    extends AutoDisposeStreamProviderElement<ModelProfile>
    with GetProfileDataRef {
  _GetProfileDataProviderElement(super.provider);

  @override
  String? get profileUid => (origin as GetProfileDataProvider).profileUid;
}

String _$updateProfileHash() => r'7cb6072902f445d4d278d75a631a837b28d70ade';

/// See also [updateProfile].
@ProviderFor(updateProfile)
const updateProfileProvider = UpdateProfileFamily();

/// See also [updateProfile].
class UpdateProfileFamily extends Family<AsyncValue<String>> {
  /// See also [updateProfile].
  const UpdateProfileFamily();

  /// See also [updateProfile].
  UpdateProfileProvider call(
    String profileUid,
    Uint8List? file,
    String newUsername,
    String newBio,
  ) {
    return UpdateProfileProvider(
      profileUid,
      file,
      newUsername,
      newBio,
    );
  }

  @override
  UpdateProfileProvider getProviderOverride(
    covariant UpdateProfileProvider provider,
  ) {
    return call(
      provider.profileUid,
      provider.file,
      provider.newUsername,
      provider.newBio,
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
  String? get name => r'updateProfileProvider';
}

/// See also [updateProfile].
class UpdateProfileProvider extends AutoDisposeFutureProvider<String> {
  /// See also [updateProfile].
  UpdateProfileProvider(
    String profileUid,
    Uint8List? file,
    String newUsername,
    String newBio,
  ) : this._internal(
          (ref) => updateProfile(
            ref as UpdateProfileRef,
            profileUid,
            file,
            newUsername,
            newBio,
          ),
          from: updateProfileProvider,
          name: r'updateProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateProfileHash,
          dependencies: UpdateProfileFamily._dependencies,
          allTransitiveDependencies:
              UpdateProfileFamily._allTransitiveDependencies,
          profileUid: profileUid,
          file: file,
          newUsername: newUsername,
          newBio: newBio,
        );

  UpdateProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileUid,
    required this.file,
    required this.newUsername,
    required this.newBio,
  }) : super.internal();

  final String profileUid;
  final Uint8List? file;
  final String newUsername;
  final String newBio;

  @override
  Override overrideWith(
    FutureOr<String> Function(UpdateProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateProfileProvider._internal(
        (ref) => create(ref as UpdateProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileUid: profileUid,
        file: file,
        newUsername: newUsername,
        newBio: newBio,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _UpdateProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateProfileProvider &&
        other.profileUid == profileUid &&
        other.file == file &&
        other.newUsername == newUsername &&
        other.newBio == newBio;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);
    hash = _SystemHash.combine(hash, file.hashCode);
    hash = _SystemHash.combine(hash, newUsername.hashCode);
    hash = _SystemHash.combine(hash, newBio.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UpdateProfileRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;

  /// The parameter `file` of this provider.
  Uint8List? get file;

  /// The parameter `newUsername` of this provider.
  String get newUsername;

  /// The parameter `newBio` of this provider.
  String get newBio;
}

class _UpdateProfileProviderElement
    extends AutoDisposeFutureProviderElement<String> with UpdateProfileRef {
  _UpdateProfileProviderElement(super.provider);

  @override
  String get profileUid => (origin as UpdateProfileProvider).profileUid;
  @override
  Uint8List? get file => (origin as UpdateProfileProvider).file;
  @override
  String get newUsername => (origin as UpdateProfileProvider).newUsername;
  @override
  String get newBio => (origin as UpdateProfileProvider).newBio;
}

String _$getBlockedProfilesHash() =>
    r'fbc0968fae200c66bf455abc626ddbaa99de4b46';

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
    r'01c8c432fae31a20c0ffd93bb831045567f9a93a';

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
String _$getProfileFromPostHash() =>
    r'97475f8e5664f934d6b0416297a5d5a071b79949';

/// See also [getProfileFromPost].
@ProviderFor(getProfileFromPost)
const getProfileFromPostProvider = GetProfileFromPostFamily();

/// See also [getProfileFromPost].
class GetProfileFromPostFamily extends Family<AsyncValue<ModelProfile>> {
  /// See also [getProfileFromPost].
  const GetProfileFromPostFamily();

  /// See also [getProfileFromPost].
  GetProfileFromPostProvider call(
    String profileUid,
  ) {
    return GetProfileFromPostProvider(
      profileUid,
    );
  }

  @override
  GetProfileFromPostProvider getProviderOverride(
    covariant GetProfileFromPostProvider provider,
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
  String? get name => r'getProfileFromPostProvider';
}

/// See also [getProfileFromPost].
class GetProfileFromPostProvider
    extends AutoDisposeFutureProvider<ModelProfile> {
  /// See also [getProfileFromPost].
  GetProfileFromPostProvider(
    String profileUid,
  ) : this._internal(
          (ref) => getProfileFromPost(
            ref as GetProfileFromPostRef,
            profileUid,
          ),
          from: getProfileFromPostProvider,
          name: r'getProfileFromPostProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getProfileFromPostHash,
          dependencies: GetProfileFromPostFamily._dependencies,
          allTransitiveDependencies:
              GetProfileFromPostFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetProfileFromPostProvider._internal(
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
    FutureOr<ModelProfile> Function(GetProfileFromPostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetProfileFromPostProvider._internal(
        (ref) => create(ref as GetProfileFromPostRef),
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
  AutoDisposeFutureProviderElement<ModelProfile> createElement() {
    return _GetProfileFromPostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetProfileFromPostProvider &&
        other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetProfileFromPostRef on AutoDisposeFutureProviderRef<ModelProfile> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;
}

class _GetProfileFromPostProviderElement
    extends AutoDisposeFutureProviderElement<ModelProfile>
    with GetProfileFromPostRef {
  _GetProfileFromPostProviderElement(super.provider);

  @override
  String get profileUid => (origin as GetProfileFromPostProvider).profileUid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
