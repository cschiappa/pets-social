import 'package:flutter/material.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/providers/theme_provider.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/resources/firebase_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: Builder(builder: (context) {
        var themeData = Provider.of<ThemeProvider>(context).themeData;
        return MaterialApp.router(
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          title: 'Pet Social',
          theme: themeData,
        );
      }),
    );
  }
}
