import 'package:flutter/material.dart';
import 'package:pets_social/features/auth/controller/auth_provider.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/theme/theme_provider.dart';
import 'package:pets_social/features/user/controller/user_provider.dart';
import 'package:pets_social/features/notification/repository/notification_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// //Riverpod Providers
// final userProvider = ChangeNotifierProvider<UserProvider>((ref) => UserProvider());
// final themeData = ChangeNotifierProvider<ThemeProvider>((ref) => ThemeProvider());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? notification = prefs.getBool('notification');

  if (notification == true) {
    await NotificationRepository().initNotifications();
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeData = ref.watch(themeProvider).themeData;

    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            final routerConfig = data != null ? loggedInRoutes : loggedOutRoutes;
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Pets Social',
              theme: themeData,
              routerConfig: routerConfig,
            );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
