import 'package:firebase_auth/firebase_auth.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/features/auth/repository/auth_repository.dart';
import 'package:pets_social/features/notification/controller/notification_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

//AUTH REPOSITORY PROVIDER
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    storageRepository: ref.read(storageRepositoryProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
}

class AuthProvider {
  AuthProvider(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
}

// @Riverpod(keepAlive: true)
// FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
//   return FirebaseAuth.instance;
// }

@Riverpod(keepAlive: true)
AuthProvider authentication(AuthenticationRef ref) {
  return AuthProvider(ref.watch(authProvider));
}

// @riverpod
// Stream authStateChanges(AuthStateChangesRef ref) {
//   return ref.watch(authRepositoryProvider).authStateChange;
// }

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authRepositoryProvider);
  return authController.authStateChange;
});
