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
    r'af975e5f8226bff37efce52be4e3533e830267b5';

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
class NumberOfUnreadChatsProvider extends AutoDisposeStreamProvider<int> {
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
    Stream<int> Function(NumberOfUnreadChatsRef provider) create,
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
  AutoDisposeStreamProviderElement<int> createElement() {
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

mixin NumberOfUnreadChatsRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `profile` of this provider.
  String get profile;
}

class _NumberOfUnreadChatsProviderElement
    extends AutoDisposeStreamProviderElement<int> with NumberOfUnreadChatsRef {
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

String _$getMessagesHash() => r'1a5a53ac8c693139ea66761b2a85db046ad83b3a';

/// See also [getMessages].
@ProviderFor(getMessages)
const getMessagesProvider = GetMessagesFamily();

/// See also [getMessages].
class GetMessagesFamily extends Family<AsyncValue<QuerySnapshot>> {
  /// See also [getMessages].
  const GetMessagesFamily();

  /// See also [getMessages].
  GetMessagesProvider call(
    String userUid,
    String otherUserUid,
  ) {
    return GetMessagesProvider(
      userUid,
      otherUserUid,
    );
  }

  @override
  GetMessagesProvider getProviderOverride(
    covariant GetMessagesProvider provider,
  ) {
    return call(
      provider.userUid,
      provider.otherUserUid,
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
  String? get name => r'getMessagesProvider';
}

/// See also [getMessages].
class GetMessagesProvider extends AutoDisposeStreamProvider<QuerySnapshot> {
  /// See also [getMessages].
  GetMessagesProvider(
    String userUid,
    String otherUserUid,
  ) : this._internal(
          (ref) => getMessages(
            ref as GetMessagesRef,
            userUid,
            otherUserUid,
          ),
          from: getMessagesProvider,
          name: r'getMessagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMessagesHash,
          dependencies: GetMessagesFamily._dependencies,
          allTransitiveDependencies:
              GetMessagesFamily._allTransitiveDependencies,
          userUid: userUid,
          otherUserUid: otherUserUid,
        );

  GetMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userUid,
    required this.otherUserUid,
  }) : super.internal();

  final String userUid;
  final String otherUserUid;

  @override
  Override overrideWith(
    Stream<QuerySnapshot> Function(GetMessagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMessagesProvider._internal(
        (ref) => create(ref as GetMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userUid: userUid,
        otherUserUid: otherUserUid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<QuerySnapshot> createElement() {
    return _GetMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMessagesProvider &&
        other.userUid == userUid &&
        other.otherUserUid == otherUserUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userUid.hashCode);
    hash = _SystemHash.combine(hash, otherUserUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetMessagesRef on AutoDisposeStreamProviderRef<QuerySnapshot> {
  /// The parameter `userUid` of this provider.
  String get userUid;

  /// The parameter `otherUserUid` of this provider.
  String get otherUserUid;
}

class _GetMessagesProviderElement
    extends AutoDisposeStreamProviderElement<QuerySnapshot>
    with GetMessagesRef {
  _GetMessagesProviderElement(super.provider);

  @override
  String get userUid => (origin as GetMessagesProvider).userUid;
  @override
  String get otherUserUid => (origin as GetMessagesProvider).otherUserUid;
}

String _$messageReadHash() => r'4877430e2302e5fccb773da2de98cf5306b48295';

/// See also [messageRead].
@ProviderFor(messageRead)
const messageReadProvider = MessageReadFamily();

/// See also [messageRead].
class MessageReadFamily extends Family<AsyncValue<void>> {
  /// See also [messageRead].
  const MessageReadFamily();

  /// See also [messageRead].
  MessageReadProvider call(
    String profileUid,
    String receiverUid,
  ) {
    return MessageReadProvider(
      profileUid,
      receiverUid,
    );
  }

  @override
  MessageReadProvider getProviderOverride(
    covariant MessageReadProvider provider,
  ) {
    return call(
      provider.profileUid,
      provider.receiverUid,
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
  String? get name => r'messageReadProvider';
}

/// See also [messageRead].
class MessageReadProvider extends AutoDisposeFutureProvider<void> {
  /// See also [messageRead].
  MessageReadProvider(
    String profileUid,
    String receiverUid,
  ) : this._internal(
          (ref) => messageRead(
            ref as MessageReadRef,
            profileUid,
            receiverUid,
          ),
          from: messageReadProvider,
          name: r'messageReadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messageReadHash,
          dependencies: MessageReadFamily._dependencies,
          allTransitiveDependencies:
              MessageReadFamily._allTransitiveDependencies,
          profileUid: profileUid,
          receiverUid: receiverUid,
        );

  MessageReadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileUid,
    required this.receiverUid,
  }) : super.internal();

  final String profileUid;
  final String receiverUid;

  @override
  Override overrideWith(
    FutureOr<void> Function(MessageReadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessageReadProvider._internal(
        (ref) => create(ref as MessageReadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileUid: profileUid,
        receiverUid: receiverUid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _MessageReadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessageReadProvider &&
        other.profileUid == profileUid &&
        other.receiverUid == receiverUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileUid.hashCode);
    hash = _SystemHash.combine(hash, receiverUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MessageReadRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `profileUid` of this provider.
  String get profileUid;

  /// The parameter `receiverUid` of this provider.
  String get receiverUid;
}

class _MessageReadProviderElement extends AutoDisposeFutureProviderElement<void>
    with MessageReadRef {
  _MessageReadProviderElement(super.provider);

  @override
  String get profileUid => (origin as MessageReadProvider).profileUid;
  @override
  String get receiverUid => (origin as MessageReadProvider).receiverUid;
}

String _$getLastMessageHash() => r'afd12187c8207cdf64dd4fefea01c1460a4767f1';

/// See also [getLastMessage].
@ProviderFor(getLastMessage)
const getLastMessageProvider = GetLastMessageFamily();

/// See also [getLastMessage].
class GetLastMessageFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [getLastMessage].
  const GetLastMessageFamily();

  /// See also [getLastMessage].
  GetLastMessageProvider call(
    String receiverUid,
    String senderUid,
  ) {
    return GetLastMessageProvider(
      receiverUid,
      senderUid,
    );
  }

  @override
  GetLastMessageProvider getProviderOverride(
    covariant GetLastMessageProvider provider,
  ) {
    return call(
      provider.receiverUid,
      provider.senderUid,
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
  String? get name => r'getLastMessageProvider';
}

/// See also [getLastMessage].
class GetLastMessageProvider
    extends AutoDisposeStreamProvider<List<Map<String, dynamic>>> {
  /// See also [getLastMessage].
  GetLastMessageProvider(
    String receiverUid,
    String senderUid,
  ) : this._internal(
          (ref) => getLastMessage(
            ref as GetLastMessageRef,
            receiverUid,
            senderUid,
          ),
          from: getLastMessageProvider,
          name: r'getLastMessageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getLastMessageHash,
          dependencies: GetLastMessageFamily._dependencies,
          allTransitiveDependencies:
              GetLastMessageFamily._allTransitiveDependencies,
          receiverUid: receiverUid,
          senderUid: senderUid,
        );

  GetLastMessageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.receiverUid,
    required this.senderUid,
  }) : super.internal();

  final String receiverUid;
  final String senderUid;

  @override
  Override overrideWith(
    Stream<List<Map<String, dynamic>>> Function(GetLastMessageRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetLastMessageProvider._internal(
        (ref) => create(ref as GetLastMessageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        receiverUid: receiverUid,
        senderUid: senderUid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Map<String, dynamic>>> createElement() {
    return _GetLastMessageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetLastMessageProvider &&
        other.receiverUid == receiverUid &&
        other.senderUid == senderUid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, receiverUid.hashCode);
    hash = _SystemHash.combine(hash, senderUid.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetLastMessageRef
    on AutoDisposeStreamProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `receiverUid` of this provider.
  String get receiverUid;

  /// The parameter `senderUid` of this provider.
  String get senderUid;
}

class _GetLastMessageProviderElement
    extends AutoDisposeStreamProviderElement<List<Map<String, dynamic>>>
    with GetLastMessageRef {
  _GetLastMessageProviderElement(super.provider);

  @override
  String get receiverUid => (origin as GetLastMessageProvider).receiverUid;
  @override
  String get senderUid => (origin as GetLastMessageProvider).senderUid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
