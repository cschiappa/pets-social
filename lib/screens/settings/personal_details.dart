import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class PersonalDetailsPage extends StatelessWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Personal Details'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Username'),
            subtitle: Text(profile!.username),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email'),
            subtitle: Text(profile.email),
          ),
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Account Birthday'),
            subtitle: Text(FirebaseAuth
                .instance.currentUser!.metadata.creationTime
                .toString()),
          ),
        ],
      ),
    );
  }
}
