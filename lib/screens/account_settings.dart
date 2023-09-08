import 'package:flutter/material.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/resources/auth_methods.dart';
import 'package:pets_social/widgets/text_field_input.dart';

import '../utils/utils.dart';
import 'login_screen.dart';

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

  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      AuthMethods().deleteUserAccount();
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

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
            onTap: () async {
              String currentPassword = _currentPasswordController.text;
              String newPassword = _passwordController.text;
              String newPasswordConfirmation = _newPasswordController.text;
              bool isCurrentPasswordValid =
                  await AuthMethods().verifyCurrentPassword(currentPassword);

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
                        onPressed: () {
                          if (isCurrentPasswordValid) {
                            if (newPassword == newPasswordConfirmation) {
                              AuthMethods()
                                  .changePassword(context, newPassword);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Passwords do not match."),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Current password is incorrect"),
                              ),
                            );
                          }
                        },
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                title:
                                    Text('Please introduce your login details'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // text field input for email
                                    TextFieldInput(
                                      hintText: 'Enter your email',
                                      textInputType: TextInputType.emailAddress,
                                      textEditingController: _emailController,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    //text field unput for password
                                    TextFieldInput(
                                      hintText: 'Enter your password',
                                      textInputType: TextInputType.text,
                                      textEditingController:
                                          _passwordController,
                                      isPass: true,
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      loginUser();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text('Delete Account'),
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
