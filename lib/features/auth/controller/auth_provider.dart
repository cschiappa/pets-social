import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/features/auth/repository/auth_repository.dart';
import 'package:pets_social/features/notification/controller/notification_provider.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

//AUTH REPOSITORY PROVIDER (instance)
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    storageRepository: ref.read(storageRepositoryProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
}

//Authentication changes provider
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authRepositoryProvider);
  return authController.authStateChange;
});
