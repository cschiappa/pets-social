import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/colors.dart';

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
    light = prefs.getBool('notification') ?? true;
    setState(() {
      light = light;
    });
  }

  Future<void> setNotificationPreferences(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      light = value;
    });
    await prefs.setBool('notification', value); // Save the preference
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text('Notifications Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications_off),
            title: Text('Disable Notifications'),
            trailing: SizedBox(
              height: 35,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  value: light,
                  activeColor: pinkColor,
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
