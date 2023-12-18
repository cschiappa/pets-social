// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatServiceHash() => r'e511f9b92c80ccf9d248b4e67eafd8f6a71511e8';

/// See also [chatService].
@ProviderFor(chatService)
final chatServiceProvider = Provider<ChatService>.internal(
  chatService,
  name: r'chatServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ChatServiceRef = ProviderRef<ChatService>;
String _$numberOfUnreadChatsHash() =>
    r'4537e0a9146e3cb2e4eff57add17025233cfc404';

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

/// See also [numberOfUnreadChats].
@ProviderFor(numberOfUnreadChats)
const numberOfUnreadChatsProvider = NumberOfUnreadChatsFamily();

/// See also [numberOfUnreadChats].
class NumberOfUnreadChatsFamily extends Family<AsyncValue<int>> {
  /// See also [numberOfUnreadChats].
  const NumberOfUnreadChatsFamily();

  /// See also [numberOfUnreadChats].
  NumberOfUnreadChatsProvider call(
    String profile,
  ) {
    return NumberOfUnreadChatsProvider(
      profile,
    );
  }

  @override
  NumberOfUnreadChatsProvider getProviderOverride(
    covariant NumberOfUnreadChatsProvider provider,
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
  String? get name => r'numberOfUnreadChatsProvider';
}

/// See also [numberOfUnreadChats].
class NumberOfUnreadChatsProvider extends AutoDisposeFutureProvider<int> {
  /// See also [numberOfUnreadChats].
  NumberOfUnreadChatsProvider(
    String profile,
  ) : this._internal(
          (ref) => numberOfUnreadChats(
            ref as NumberOfUnreadChatsRef,
            profile,
          ),
          from: numberOfUnreadChatsProvider,
          name: r'numberOfUnreadChatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$numberOfUnreadChatsHash,
          dependencies: NumberOfUnreadChatsFamily._dependencies,
          allTransitiveDependencies:
              NumberOfUnreadChatsFamily._allTransitiveDependencies,
          profile: profile,
        );

  NumberOfUnreadChatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profile,
  }) : super.internal();

  final String profile;

  @override
  Override overrideWith(
    FutureOr<int> Function(NumberOfUnreadChatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NumberOfUnreadChatsProvider._internal(
        (ref) => create(ref as NumberOfUnreadChatsRef),
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
  AutoDisposeFutureProviderElement<int> createElement() {
    return _NumberOfUnreadChatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NumberOfUnreadChatsProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NumberOfUnreadChatsRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `profile` of this provider.
  String get profile;
}

class _NumberOfUnreadChatsProviderElement
    extends AutoDisposeFutureProviderElement<int> with NumberOfUnreadChatsRef {
  _NumberOfUnreadChatsProviderElement(super.provider);

  @override
  String get profile => (origin as NumberOfUnreadChatsProvider).profile;
}

String _$getChatsListHash() => r'73c296776003e4942d5e18f021af0c026a9d76b6';

/// See also [getChatsList].
@ProviderFor(getChatsList)
const getChatsListProvider = GetChatsListFamily();

/// See also [getChatsList].
class GetChatsListFamily extends Family<AsyncValue<List<DocumentSnapshot>>> {
  /// See also [getChatsList].
  const GetChatsListFamily();

  /// See also [getChatsList].
  GetChatsListProvider call(
    ModelProfile? profile,
  ) {
    return GetChatsListProvider(
      profile,
    );
  }

  @override
  GetChatsListProvider getProviderOverride(
    covariant GetChatsListProvider provider,
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
  String? get name => r'getChatsListProvider';
}

/// See also [getChatsList].
class GetChatsListProvider
    extends AutoDisposeFutureProvider<List<DocumentSnapshot>> {
  /// See also [getChatsList].
  GetChatsListProvider(
    ModelProfile? profile,
  ) : this._internal(
          (ref) => getChatsList(
            ref as GetChatsListRef,
            profile,
          ),
          from: getChatsListProvider,
          name: r'getChatsListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChatsListHash,
          dependencies: GetChatsListFamily._dependencies,
          allTransitiveDependencies:
              GetChatsListFamily._allTransitiveDependencies,
          profile: profile,
        );

  GetChatsListProvider._internal(
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
    FutureOr<List<DocumentSnapshot>> Function(GetChatsListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetChatsListProvider._internal(
        (ref) => create(ref as GetChatsListRef),
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
    return _GetChatsListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChatsListProvider && other.profile == profile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetChatsListRef on AutoDisposeFutureProviderRef<List<DocumentSnapshot>> {
  /// The parameter `profile` of this provider.
  ModelProfile? get profile;
}

class _GetChatsListProviderElement
    extends AutoDisposeFutureProviderElement<List<DocumentSnapshot>>
    with GetChatsListRef {
  _GetChatsListProviderElement(super.provider);

  @override
  ModelProfile? get profile => (origin as GetChatsListProvider).profile;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
