import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../models/profile.dart';
import '../../providers/user_provider.dart';
import '../../resources/auth_methods.dart';
import '../../resources/firestore_methods.dart';
import '../../widgets/text_field_input.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        title: const Text('Profiles'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: _buildProfileList(),
    );
  }

  //build a list of user's profiles
  Widget _buildProfileList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('profiles')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildProfileListItem(doc))
              .toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildProfileListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    //display all users except current user
    return ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(data['photoUrl']),
        ),
        title: Text(data['username']),
        trailing: TextButton(
            child: Text('Delete'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:
                        Text('Are you sure you want to delete this profile?'),
                    content: Text(
                        'If you proceed your profile will be deleted permanently and everything associated with this profile will be lost.'),
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
                                title: Text('Please introduce your password'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                    onPressed: () async {
                                      String currentPassword =
                                          _passwordController.text;

                                      bool isCurrentPasswordValid =
                                          await AuthMethods()
                                              .verifyCurrentPassword(
                                                  currentPassword);
                                      if (isCurrentPasswordValid) {
                                        FirestoreMethods().deleteProfile(
                                            data['profileUid'], context);
                                        _passwordController.clear();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Current password is incorrect"),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('Delete Profile'),
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
            }));
  }
}
