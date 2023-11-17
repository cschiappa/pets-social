import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/screens/settings/account_settings.dart';
import 'package:pets_social/screens/settings/blocked_accounts.dart';
import 'package:pets_social/screens/settings/feedback.dart';
import 'package:pets_social/screens/settings/notification_settings.dart';
import 'package:pets_social/utils/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Row(
          children: [
            Text('Settings'),
          ],
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account Settings'),
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const AccountSettingsPage(),
              //   ),
              // );
              context.goNamed(AppRouter.accountSettings.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const NotificationsSettings(),
              //   ),
              // );
              context.goNamed(AppRouter.notifications.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_off),
            title: const Text('Blocked Accounts'),
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => const BlockedAccountsPage(),
              //   ),
              // );
              context.goNamed(AppRouter.blockedAccounts.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Report a Problem'),
            onTap: () {
              // Navigator.of(context).pushReplacement(MaterialPageRoute(
              //     builder: (context) => const FeedbackScreen()));
              context.goNamed(AppRouter.feedback.name);
            },
          )
        ],
      ),
    );
  }
}
