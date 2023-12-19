// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
