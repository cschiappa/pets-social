import 'package:flutter/material.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/resources/auth_methods.dart';
import 'package:pets_social/widgets/text_field_input.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool passEnable = true;

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
            leading: Icon(Icons.groups),
            title: Text('Profiles'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Personal Details'),
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: Text('Change Password'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Current password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Enter your current password:'),
                        ),
                        TextFieldInput(
                            textEditingController: _currentPasswordController,
                            isPass: passEnable,
                            hintText: 'Current password',
                            textInputType: TextInputType.text),
                        //Enter new password
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 8.0),
                          child: Text('Enter your new password:'),
                        ),
                        TextFieldInput(
                            textEditingController: _passwordController,
                            isPass: passEnable,
                            hintText: 'New password',
                            textInputType: TextInputType.text),
                        //Repeat Password
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 8.0),
                          child: Text('Repeat your new password:'),
                        ),
                        TextFieldInput(
                            textEditingController: _newPasswordController,
                            isPass: passEnable,
                            hintText: 'Repeat new password',
                            textInputType: TextInputType.text),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {},
                        child: Text('Save'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Account'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:
                        Text('Are you sure you want to delete your account?'),
                    content: Text(
                        'If you proceed your account will be deleted permanently and everything will be lost.'),
                    actions: [
                      TextButton(
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        onPressed: () {},
                      ),
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
