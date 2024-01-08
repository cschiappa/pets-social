// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRepositoryHash() =>
    r'21f657890504d7ee3623c17f551abde3246588f8';

/// See also [notificationRepository].
@ProviderFor(notificationRepository)
final notificationRepositoryProvider =
    Provider<NotificationRepository>.internal(
  notificationRepository,
  name: r'notificationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotificationRepositoryRef = ProviderRef<NotificationRepository>;
String _$getNotificationsHash() => r'c9be8daa30ce6c4a0bd96a108e984eab0e608f87';

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

/// See also [getNotifications].
@ProviderFor(getNotifications)
const getNotificationsProvider = GetNotificationsFamily();

/// See also [getNotifications].
class GetNotificationsFamily
    extends Family<AsyncValue<List<DocumentSnapshot>>> {
  /// See also [getNotifications].
  const GetNotificationsFamily();

  /// See also [getNotifications].
  GetNotificationsProvider call(
    String profileUid,
  ) {
    return GetNotificationsProvider(
      profileUid,
    );
  }

  @override
  GetNotificationsProvider getProviderOverride(
    covariant GetNotificationsProvider provider,
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
  String? get name => r'getNotificationsProvider';
}

/// See also [getNotifications].
class GetNotificationsProvider
    extends AutoDisposeStreamProvider<List<DocumentSnapshot>> {
  /// See also [getNotifications].
  GetNotificationsProvider(
    String profileUid,
  ) : this._internal(
          (ref) => getNotifications(
            ref as GetNotificationsRef,
            profileUid,
          ),
          from: getNotificationsProvider,
          name: r'getNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getNotificationsHash,
          dependencies: GetNotificationsFamily._dependencies,
          allTransitiveDependencies:
              GetNotificationsFamily._allTransitiveDependencies,
          profileUid: profileUid,
        );

  GetNotificationsProvider._internal(
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
    Stream<List<DocumentSnapshot>> Function(GetNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetNotificationsProvider._internal(
        (ref) => create(ref as GetNotificationsRef),
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
  AutoDisposeStreamProviderElement<List<DocumentSnapshot>> createElement() {
    return _GetNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetNotificationsProvider && other.profileUid == profileUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetNotificationsRef
    on AutoDisposeStreamProviderRef<List<DocumentSnapshot>> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;
}

class _GetNotificationsProviderElement
    extends AutoDisposeStreamProviderElement<List<DocumentSnapshot>>
    with GetNotificationsRef {
  _GetNotificationsProviderElement(super.provider);

  @override
  String get profileUid => (origin as GetNotificationsProvider).profileUid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
