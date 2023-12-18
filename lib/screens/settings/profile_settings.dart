import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/main.dart';
import '../../services/auth_methods.dart';
import '../../services/firestore_methods.dart';
import '../../widgets/text_field_input.dart';

class ProfileSettings extends ConsumerStatefulWidget {
  const ProfileSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends ConsumerState<ProfileSettings> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Profiles'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: _buildProfileList(),
    );
  }

  //USER'S PROFILES LIST
  Widget _buildProfileList() {
    final ThemeData theme = Theme.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('profiles').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            color: theme.colorScheme.secondary,
          );
        }

        final profileDocs = snapshot.data!.docs;
        final hasMultipleProfiles = profileDocs.length > 1;

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildProfileListItem(doc, hasMultipleProfiles)).toList(),
        );
      },
    );
  }

  //USER'S PROFILES LIST ITEMS
  Widget _buildProfileListItem(DocumentSnapshot document, bool hasMultipleProfiles) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except current user
    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundImage: NetworkImage(data['photoUrl']),
      ),
      title: Text(data['username']),
      trailing: hasMultipleProfiles
          ? TextButton(
              child: const Text('Delete'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Are you sure you want to delete this profile?'),
                      content: const Text('If you proceed your profile will be deleted permanently and everything associated with this profile will be lost.'),
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
                                          FirestoreMethods().deleteProfile(data['profileUid'], context).then((value) => ref.read(userProvider).disposeProfile());
                                          _passwordController.clear();
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        } else {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Current password is incorrect"),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Delete Profile'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _passwordController.clear();
                                        Navigator.of(context).pop();
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
                          child: const Text(
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
            )
          : null,
    );
  }
}
