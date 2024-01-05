import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pets_social/features/profile/controller/profile_provider.dart';
import 'package:pets_social/models/profile.dart';

class PersonalDetailsPage extends ConsumerWidget {
  const PersonalDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ModelProfile profile = ref.watch(userProvider)!;
    final ThemeData theme = Theme.of(context);
    final DateFormat format = DateFormat("dd/MM/yyyy");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text('Personal Details'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Username'),
            subtitle: Text(profile.username),
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email'),
            subtitle: Text(profile.email),
          ),
          ListTile(
            leading: const Icon(Icons.cake),
            title: const Text('Account Birthday'),
            subtitle: Text(format.format(FirebaseAuth.instance.currentUser!.metadata.creationTime!)),
          ),
        ],
      ),
    );
  }
}
