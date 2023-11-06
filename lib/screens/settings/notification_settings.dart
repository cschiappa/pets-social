import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/colors.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool light = true;
  final String notificationsPref = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
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
                  onChanged: (bool value) async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(
                      () {
                        light = value;
                      },
                    );
                    value == light
                        ? await prefs.setBool('notification', true)
                        : await prefs.setBool('notification', false);
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
