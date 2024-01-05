import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/auth/screens/forgot_password_page.dart';
import 'package:pets_social/features/auth/screens/login_screen.dart';
import 'package:pets_social/features/auth/screens/signup_screen.dart';
import 'package:pets_social/features/chat/screens/chat_list_page.dart';
import 'package:pets_social/features/chat/screens/chat_page.dart';
import 'package:pets_social/features/post/screens/add_post_screen.dart';
import 'package:pets_social/features/post/screens/comments_screen.dart';
import 'package:pets_social/features/post/screens/open_post_screen.dart';
import 'package:pets_social/features/profile/screens/profile_screen.dart';
import 'package:pets_social/features/profile/screens/settings/account_settings.dart';
import 'package:pets_social/features/profile/screens/settings/blocked_accounts.dart';
import 'package:pets_social/features/profile/screens/settings/notification_settings.dart';
import 'package:pets_social/features/profile/screens/settings/personal_details.dart';
import 'package:pets_social/features/profile/screens/settings/profile_settings.dart';
import 'package:pets_social/features/profile/screens/settings/saved_posts_screen.dart';
import 'package:pets_social/features/profile/screens/settings/settings.dart';
import 'package:pets_social/responsive/mobile_screen_layout.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/responsive/web_screen_layout.dart';
import 'package:pets_social/features/feed/feed_screen.dart';
import 'package:pets_social/features/prizes/prizes_screen.dart';
import 'package:pets_social/features/search/search_screen.dart';
import 'package:pets_social/features/welcome_screens/main_welcome_screen.dart';

class Routes {
  final String name;
  final String path;

  const Routes({required this.name, required this.path});
}

class AppRouter {
  //Initial
  static const Routes initial = Routes(name: '/', path: '/');
  //Root
  static const Routes welcomePage = Routes(name: 'welcomePage', path: '/welcome');
  static const Routes login = Routes(name: 'login', path: '/login');
  static const Routes signup = Routes(name: 'signup', path: '/signup');
  static const Routes recoverPassword = Routes(name: 'recoverPassword', path: '/recover/password');

  //Shell
  static const Routes feedScreen = Routes(name: 'feedScreen', path: '/feed');
  static const Routes searchScreen = Routes(name: 'searchScreen', path: '/search');
  static const Routes addpostScreen = Routes(name: 'addpostScreen', path: '/addpost');
  static const Routes prizesScreen = Routes(name: 'prizesScreen', path: '/prizes');
  static const Routes profileScreen = Routes(name: 'profileScreen', path: '/profile');

  //Navigate to profile
  static const Routes navigateToProfile = Routes(name: 'navigateToProfile', path: '/:profileUid');

  //FeedScreen Sub-Routes
  static const Routes openPostFromDeeplink = Routes(name: 'openPostFromDeeplink', path: '/post/:postId/:profileUid/:username');
  static const Routes profileFromFeed = Routes(name: 'profileFromFeed', path: 'profile/:profileUid');
  static const Routes openPostFromFeed = Routes(name: 'openPostFromFeed', path: 'postFeed/:postId/:username');
  static const Routes commentsFromFeed = Routes(name: 'commentsFromFeed', path: 'post/:postId/:profileUid/:username/comments');
  static const Routes chatList = Routes(name: 'chatList', path: 'chatList');
  static const Routes chatPage = Routes(name: 'chatPage', path: 'chatpage/:receiverUserEmail/:receiverUserId/:receiverUsername');

  //SearchScreen Sub-Routes
  static const Routes profileFromSearch = Routes(name: 'profileFromSearch', path: 'profile/:profileUid');
  static const Routes openPostFromSearch = Routes(name: 'openPostFromSearch', path: 'postSearch/:postId/:profileUid/:username');
  static const Routes commentsFromSearch = Routes(name: 'commentsFromSearch', path: 'post/:postId/:profileUid/:username/comments');

  //PrizesScreen Sub-Routes
  static const Routes profileFromPrizes = Routes(name: 'profileFromPrizes', path: 'profile/:profileUid');
  static const Routes openPostFromPrizes = Routes(name: 'openPostFromPrizes', path: 'postSearch/:postId/:profileUid/:username');

  //ProfileScreen Sub-Routes
  static const Routes openPostFromProfile = Routes(name: 'openPostFromProfile', path: 'postProfile/:postId/:profileUid/:username');
  static const Routes commentsFromProfile = Routes(name: 'commentsFromProfile', path: 'post/:postId/:profileUid/:username/comments');
  static const Routes savedPosts = Routes(name: 'savedPosts', path: 'savedPosts');
  //Settings
  static const Routes settings = Routes(name: 'settings', path: 'settings');
  static const Routes accountSettings = Routes(name: 'accountSettings', path: 'accountSettings');
  static const Routes profileSettings = Routes(name: 'profileSettings', path: 'profileSettings');
  static const Routes personalDetails = Routes(name: 'personalDetails', path: 'personalDetails');
  static const Routes notifications = Routes(name: 'notifications', path: 'notifications');
  static const Routes blockedAccounts = Routes(name: 'blockedAccounts', path: 'blockedAccounts');
  static const Routes reportProblem = Routes(name: 'reportProblem', path: 'reportProblem');
  static const Routes feedback = Routes(name: 'feedback', path: 'feedback');
}

// FutureOr<String?> onRedirect(BuildContext context, GoRouterState state) {
//   final List<String> initialRoutes = [AppRouter.login.path, AppRouter.signup.path, AppRouter.recoverPassword.path, AppRouter.welcomePage.path];

//   final bool isInitialRoute = initialRoutes.contains(state.matchedLocation);

//   if (FirebaseAuth.instance.currentUser == null && !isInitialRoute) {
//     return AppRouter.login.path;
//   }

//   if (FirebaseAuth.instance.currentUser != null && isInitialRoute) {
//     return AppRouter.feedScreen.path;
//   }

//   return null;
// }

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter loggedOutRoutes = GoRouter(initialLocation: AppRouter.login.path, routes: <RouteBase>[
  //WELCOME SCREEN
  GoRoute(
    name: AppRouter.welcomePage.name,
    path: AppRouter.welcomePage.path,
    builder: (context, state) => const WelcomePage(),
  ),
  //LOG IN SCREEN
  GoRoute(
    name: AppRouter.login.name,
    path: AppRouter.login.path,
    builder: (context, state) => const LoginScreen(),
  ),
  //SIGN UP SCREEN
  GoRoute(
    name: AppRouter.signup.name,
    path: AppRouter.signup.path,
    builder: (context, state) => const SignupScreen(),
  ),
  //RECOVER PASSWORD
  GoRoute(
    name: AppRouter.recoverPassword.name,
    path: AppRouter.recoverPassword.path,
    builder: (context, state) => const ForgotPasswordPage(),
  ),
]);

final GoRouter loggedInRoutes = GoRouter(initialLocation: AppRouter.feedScreen.path, routes: <RouteBase>[
  //DEEPLINK OPEN POST
  GoRoute(
    name: AppRouter.openPostFromDeeplink.name,
    path: AppRouter.openPostFromDeeplink.path,
    builder: (context, state) => OpenPost(
      postId: state.pathParameters["postId"]!,
      profileUid: state.pathParameters["profileUid"]!,
      username: state.pathParameters["username"]!,
    ),
  ),
  //BOTTOM NAVIGATION BAR
  StatefulShellRoute.indexedStack(
    builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) => ResponsiveLayout(
      web: WebScreenLayout(navigationShell: navigationShell),
      mobile: MobileScreenLayout(navigationShell: navigationShell),
    ),
    branches: [
      //FEED SCREEN
      StatefulShellBranch(routes: [
        GoRoute(name: AppRouter.feedScreen.name, path: AppRouter.feedScreen.path, builder: (context, state) => const FeedScreen(), routes: <RouteBase>[
          //COMMENTS
          GoRoute(
            name: AppRouter.commentsFromFeed.name,
            path: AppRouter.commentsFromFeed.path,
            builder: (context, state) => CommentsScreen(snap: state.extra),
          ),
          //NAVIGATE TO PROFILE
          GoRoute(
            name: AppRouter.profileFromFeed.name,
            path: AppRouter.profileFromFeed.path,
            builder: (context, state) => ProfileScreen(
              profileUid: state.pathParameters["profileUid"]!,
            ),
            routes: <RouteBase>[
              //OPEN POST
              GoRoute(
                name: AppRouter.openPostFromFeed.name,
                path: AppRouter.openPostFromFeed.path,
                builder: (context, state) => OpenPost(
                  postId: state.pathParameters["postId"]!,
                  profileUid: state.pathParameters["profileUid"]!,
                  username: state.pathParameters["username"]!,
                ),
              )
            ],
          ),
          //CHAT LIST
          GoRoute(name: AppRouter.chatList.name, path: AppRouter.chatList.path, builder: (context, state) => const ChatList(), routes: <RouteBase>[
            //CHAT PAGE
            GoRoute(
              name: AppRouter.chatPage.name,
              path: AppRouter.chatPage.path,
              builder: (context, state) => ChatPage(
                receiverUserEmail: state.pathParameters["receiverUserEmail"]!,
                receiverUserID: state.pathParameters["receiverUserId"]!,
                receiverUsername: state.pathParameters["receiverUsername"]!,
              ),
            ),
          ]),
        ]),
      ]),
      //SEARCH SCREEN
      StatefulShellBranch(routes: [
        GoRoute(name: AppRouter.searchScreen.name, path: AppRouter.searchScreen.path, builder: (context, state) => const SearchScreen(), routes: <RouteBase>[
          //NAVIGATE TO PROFILE
          GoRoute(
            name: AppRouter.profileFromSearch.name,
            path: AppRouter.profileFromSearch.path,
            builder: (context, state) => ProfileScreen(
              profileUid: state.pathParameters["profileUid"]!,
            ),
          ),
          //OPEN POST
          GoRoute(
            name: AppRouter.openPostFromSearch.name,
            path: AppRouter.openPostFromSearch.path,
            builder: (context, state) => OpenPost(
              postId: state.pathParameters["postId"]!,
              profileUid: state.pathParameters["profileUid"]!,
              username: state.pathParameters["username"]!,
            ),
          ),
        ]),
      ]),
      //ADD POST SCREEN
      StatefulShellBranch(routes: [
        GoRoute(
          name: AppRouter.addpostScreen.name,
          path: AppRouter.addpostScreen.path,
          builder: (context, state) => const AddPostScreen(),
        ),
      ]),
      //PRIZES SCREEN
      StatefulShellBranch(routes: [
        GoRoute(name: AppRouter.prizesScreen.name, path: AppRouter.prizesScreen.path, builder: (context, state) => const PrizesScreen(), routes: <RouteBase>[
          //NAVIGATE TO PROFILE
          GoRoute(
            name: AppRouter.profileFromPrizes.name,
            path: AppRouter.profileFromPrizes.path,
            builder: (context, state) => ProfileScreen(
              profileUid: state.pathParameters["profileUid"]!,
            ),
          ),
          //OPEN POST
          GoRoute(
            name: AppRouter.openPostFromPrizes.name,
            path: AppRouter.openPostFromPrizes.path,
            builder: (context, state) => OpenPost(
              postId: state.pathParameters["postId"]!,
              profileUid: state.pathParameters["profileUid"]!,
              username: state.pathParameters["username"]!,
            ),
          ),
        ]),
      ]),
      //PROFILE SCREEN
      StatefulShellBranch(routes: [
        GoRoute(
            name: AppRouter.profileScreen.name,
            path: AppRouter.profileScreen.path,
            builder: (context, state) {
              return const ProfileScreen();
            },
            routes: <RouteBase>[
              //OPEN POST
              GoRoute(
                name: AppRouter.openPostFromProfile.name,
                path: AppRouter.openPostFromProfile.path,
                builder: (context, state) => OpenPost(
                  postId: state.pathParameters['postId']!,
                  profileUid: state.pathParameters['profileUid']!,
                  username: state.pathParameters['username']!,
                ),
                routes: <RouteBase>[
                  GoRoute(
                    name: AppRouter.commentsFromProfile.name,
                    path: AppRouter.commentsFromProfile.path,
                    builder: (context, state) => CommentsScreen(snap: state.extra),
                  )
                ],
              ),
              //SAVED POSTS
              GoRoute(
                name: AppRouter.savedPosts.name,
                path: AppRouter.savedPosts.path,
                builder: (context, state) => SavedPosts(snap: state.extra),
              ),
              //SETTINGS
              GoRoute(name: AppRouter.settings.name, path: AppRouter.settings.path, builder: (context, state) => const SettingsPage(), routes: <RouteBase>[
                //ACCOUNT SETTINGS
                GoRoute(name: AppRouter.accountSettings.name, path: AppRouter.accountSettings.path, builder: (context, state) => const AccountSettingsPage(), routes: <RouteBase>[
                  //PROFILE SETTINGS
                  GoRoute(
                    name: AppRouter.profileSettings.name,
                    path: AppRouter.profileSettings.path,
                    builder: (context, state) => const ProfileSettings(),
                  ),
                  //PERSONAL DETAILS
                  GoRoute(
                    name: AppRouter.personalDetails.name,
                    path: AppRouter.personalDetails.path,
                    builder: (context, state) => const PersonalDetailsPage(),
                  ),
                ]),
                //NOTIFICATIONS
                GoRoute(
                  name: AppRouter.notifications.name,
                  path: AppRouter.notifications.path,
                  builder: (context, state) => const NotificationsSettings(),
                ),
                //BLOCKED ACCOUNTS
                GoRoute(
                  name: AppRouter.blockedAccounts.name,
                  path: AppRouter.blockedAccounts.path,
                  builder: (context, state) => const BlockedAccountsPage(),
                ),
              ])
            ]),
        GoRoute(
          name: AppRouter.navigateToProfile.name,
          path: AppRouter.navigateToProfile.path,
          builder: (context, state) => ProfileScreen(
            profileUid: state.pathParameters["profileUid"]!,
          ),
        ),
      ]),
    ],
  )
]);
