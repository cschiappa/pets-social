import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/widgets/text_field_input.dart';

import '../../utils/global_variables.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordLinkToEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                  'If this email exists, we have sent you a password reset link.'),
            );
          });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
                'If this email exists, we have sent you a password reset link.'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Text(
                'Enter your email and we will send you a password reset link:'),

            const SizedBox(
              height: 24,
            ),
            //email textfield
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Email',
                textInputType: TextInputType.emailAddress),

            const SizedBox(
              height: 24,
            ),

            //button to send
            InkWell(
              onTap: () {
                passwordLinkToEmail();
                _emailController.clear();
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: ShapeDecoration(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: theme.colorScheme.secondary,
                ),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
