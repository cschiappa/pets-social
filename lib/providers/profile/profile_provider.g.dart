// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getBlockedProfilesHash() =>
    r'a7149fab852e309e16547116934596d087010776';

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
    extends Family<AsyncValue<List<DocumentSnapshot>>> {
  /// See also [getBlockedProfiles].
  const GetBlockedProfilesFamily();

  /// See also [getBlockedProfiles].
  GetBlockedProfilesProvider call(
    ModelProfile? profile,
  ) {
    return GetBlockedProfilesProvider(
      profile,
    );
  }

  @override
  GetBlockedProfilesProvider getProviderOverride(
    covariant GetBlockedProfilesProvider provider,
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
  String? get name => r'getBlockedProfilesProvider';
}

/// See also [getBlockedProfiles].
class GetBlockedProfilesProvider
    extends AutoDisposeFutureProvider<List<DocumentSnapshot>> {
  /// See also [getBlockedProfiles].
  GetBlockedProfilesProvider(
    ModelProfile? profile,
  ) : this._internal(
          (ref) => getBlockedProfiles(
            ref as GetBlockedProfilesRef,
            profile,
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
          profile: profile,
        );

  GetBlockedProfilesProvider._internal(
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
    FutureOr<List<DocumentSnapshot>> Function(GetBlockedProfilesRef provider)
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
        profile: profile,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DocumentSnapshot>> createElement() {
    return _GetBlockedProfilesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBlockedProfilesProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetBlockedProfilesRef
    on AutoDisposeFutureProviderRef<List<DocumentSnapshot>> {
  /// The parameter `profile` of this provider.
  ModelProfile? get profile;
}

class _GetBlockedProfilesProviderElement
    extends AutoDisposeFutureProviderElement<List<DocumentSnapshot>>
    with GetBlockedProfilesRef {
  _GetBlockedProfilesProviderElement(super.provider);

  @override
  ModelProfile? get profile => (origin as GetBlockedProfilesProvider).profile;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
