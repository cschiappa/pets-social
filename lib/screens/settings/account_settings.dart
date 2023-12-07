import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pets_social/resources/auth_methods.dart';
import 'package:pets_social/widgets/text_field_input.dart';

import '../../features/app_router.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool passEnable = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Row(
          children: [
            Text('Account Settings'),
          ],
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Profiles'),
            onTap: () {
              context.goNamed(AppRouter.profileSettings.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Personal Details'),
            onTap: () {
              context.goNamed(AppRouter.personalDetails.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () async {
              showDialog(
                context: context,
                builder: ((context) {
                  return AlertDialog(
                    title: const Text('Change Password'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Current password
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Enter your current password:'),
                        ),
                        TextFieldInput(textEditingController: _currentPasswordController, isPass: passEnable, labelText: 'Current password', textInputType: TextInputType.text),
                        //Enter new password
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 8.0),
                          child: Text('Enter your new password:'),
                        ),
                        TextFieldInput(textEditingController: _passwordController, isPass: passEnable, labelText: 'New password', textInputType: TextInputType.text),
                        //Repeat Password
                        const Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 8.0),
                          child: Text('Repeat your new password:'),
                        ),
                        TextFieldInput(
                          textEditingController: _newPasswordController,
                          isPass: passEnable,
                          labelText: 'Repeat new password',
                          textInputType: TextInputType.text,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          String currentPassword = _currentPasswordController.text;
                          String newPassword = _passwordController.text;
                          String newPasswordConfirmation = _newPasswordController.text;
                          bool isCurrentPasswordValid = await AuthMethods().verifyCurrentPassword(currentPassword);
                          if (isCurrentPasswordValid) {
                            if (AuthMethods().isPasswordValid(newPassword)) {
                              if (newPassword == newPasswordConfirmation) {
                                if (!mounted) return;
                                AuthMethods().changePassword(context, newPassword);

                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                                _passwordController.clear();
                              } else {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Passwords do not match."),
                                  ),
                                );
                              }
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Your new password must contain a minimum of 5 letters, at least 1 upper case letter, 1 lower case letter, 1 numeric character and one special character."),
                                ),
                              );
                            }
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Current password is incorrect"),
                              ),
                            );
                          }
                        },
                        child: const Text('Save'),
                      ),
                      TextButton(
                        onPressed: () {
                          _currentPasswordController.clear();
                          _newPasswordController.clear();
                          _passwordController.clear();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Account'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Are you sure you want to delete your account?'),
                    content: const Text('If you proceed your account will be deleted permanently and everything will be lost.'),
                    actions: [
                      TextButton(
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                title: const Text('Please introduce your password'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //text field unput for password
                                    TextFieldInput(
                                      labelText: 'Enter your password',
                                      textInputType: TextInputType.text,
                                      textEditingController: _passwordController,
                                      isPass: true,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      String currentPassword = _passwordController.text;

                                      bool isCurrentPasswordValid = await AuthMethods().verifyCurrentPassword(currentPassword);
                                      if (isCurrentPasswordValid) {
                                        if (!mounted) return;
                                        AuthMethods().deleteUserAccount(context);
                                      } else {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Current password is incorrect"),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Delete Account'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16, color: theme.colorScheme.tertiary),
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
