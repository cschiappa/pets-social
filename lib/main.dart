import 'package:flutter/material.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/providers/theme/theme_provider.dart';
import 'package:pets_social/providers/user/user_provider.dart';
import 'package:pets_social/services/firebase_notifications.dart';
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
    await FirebaseApi().initNotifications();
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

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'Pet Social',
      theme: themeData,
    );
  }
}
