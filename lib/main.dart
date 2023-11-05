import 'package:feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/resources/firebase_messaging.dart';
import 'package:pets_social/responsive/mobile_screen_layout.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/responsive/web_screen_layout.dart';
import 'package:pets_social/screens/initial_screens/login_screen.dart';
import 'package:pets_social/screens/open_post_screen.dart';
import 'package:pets_social/screens/prizes_screen.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:regex_router/regex_router.dart';
import 'firebase_options.dart';
import 'screens/notifications_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pet Social',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
          highlightColor: Colors.white,
        ),
        navigatorKey: navigatorKey,
        home: BetterFeedback(
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              return const LoginScreen();
            },
          ),
        ),
        routes: {
          NotificationScreen.route: (context) => const PrizesScreen(),
        },
        onGenerateRoute: (settings) {
          final router = RegexRouter.create({
            // Access "object" arguments from `NavigatorState.pushNamed`.
            "post/:postId/:profileUid/:username": (context, args) => OpenPost(
                  postId: args["postId"]!,
                  profileUid: args["profileUid"]!,
                  username: args["username"]!,
                ),
          });

          return router.generateRoute(settings);
        },
      ),
    );
  }
}
