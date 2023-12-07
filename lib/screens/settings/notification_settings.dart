import 'package:flutter/material.dart';
import 'package:pets_social/resources/firebase_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  late bool light;
  final String notificationsPref = '';

  @override
  void initState() {
    super.initState();
    getNotificationPreferences();
  }

  Future<void> getNotificationPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      light = prefs.getBool('notification') ?? true;
    });
  }

  Future<void> setNotificationPreferences(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      light = value;
    });
    await prefs.setBool('notification', value);
    //Verify the value of notification
    if (value == true) {
      FirebaseApi().initNotifications();
    } else {
      FirebaseApi().removeTokenFromDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text('Notifications Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Allow Notifications'),
            trailing: SizedBox(
              height: 35,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  value: light,
                  activeColor: theme.colorScheme.secondary,
                  onChanged: (bool value) {
                    setNotificationPreferences(value);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
