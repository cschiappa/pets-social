import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/providers/theme/theme_provider.dart';
import 'package:pets_social/services/firestore_methods.dart';
import 'package:pets_social/widgets/bottom_sheet.dart';
import 'package:pets_social/widgets/text_field_input.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final TextEditingController _problemSummaryController = TextEditingController();
  final TextEditingController _problemDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Row(
          children: [
            Text('Settings'),
          ],
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account Settings'),
            onTap: () {
              context.goNamed(AppRouter.accountSettings.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            onTap: () {
              context.goNamed(AppRouter.blockedAccounts.name);
            },
            trailing: Switch(
              value: ref.watch(themeProvider).themeData.brightness == Brightness.dark,
              onChanged: (value) {
                ref.read(themeProvider).toggleTheme();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              context.goNamed(AppRouter.notifications.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_off),
            title: const Text('Blocked Accounts'),
            onTap: () {
              context.goNamed(AppRouter.blockedAccounts.name);
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Report a Problem'),
            onTap: () {
              _feedbackBottomSheet(context);
            },
          )
        ],
      ),
    );
  }

  //FEEDBACK BOTTOMSHEET
  _feedbackBottomSheet(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return CustomBottomSheet.show(context: context, listWidget: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Report a Problem'),
          const SizedBox(
            height: 20,
          ),
          TextFieldInput(
            textEditingController: _problemSummaryController,
            labelText: 'Summary',
            textInputType: TextInputType.text,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _problemDetailsController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.secondary),
              ),
              labelText: 'Give a description of the problem...',
              alignLabelWithHint: true,
            ),
            maxLines: 6,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.colorScheme.tertiary),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              FilledButton.tonal(
                onPressed: () => FirestoreMethods().uploadFeedback(_problemSummaryController.text, _problemDetailsController.text).then(
                  (value) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Feedback sent successfully.'),
                      ),
                    );
                  },
                ),
                child: const Text('Send'),
              ),
            ],
          )
        ],
      )
    ]);
  }
}
