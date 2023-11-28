import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/resources/auth_methods.dart';

import 'package:pets_social/utils/utils.dart';
import 'package:pets_social/widgets/text_field_input.dart';

import '../../utils/global_variables.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      if (!mounted) return;
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => const ResponsiveLayout(
      //       mobileScreenLayout: MobileScreenLayout(),
      //       webScreenLayout: WebScreenLayout(),
      //     ),
      //   ),
      //   (_) => false,
      // );
      context.goNamed(AppRouter.feedScreen.name);
    } else {
      if (!mounted) return;
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(flex: 2, fit: FlexFit.loose, child: Container()),
                    // svg image
                    Image.asset(
                      'assets/logo.png',
                      color: theme.colorScheme.primary,
                      height: 64,
                    ),
                    const SizedBox(height: 64),
                    // text field input for email
                    TextFieldInput(
                      labelText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //text field unput for password
                    TextFieldInput(
                      labelText: 'Password',
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      isPass: true,
                    ),

                    InkWell(
                      onTap: () =>
                          context.pushNamed(AppRouter.recoverPassword.name),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    //button login
                    InkWell(
                      onTap: loginUser,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: ShapeDecoration(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            color: theme.colorScheme.secondary),
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: theme.colorScheme.primary,
                                ),
                              )
                            : const Text('Log in'),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(flex: 2, child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: const Text("Don't have an account?"),
                        ),
                        InkWell(
                          onTap: () =>
                              context.goNamed(AppRouter.welcomePage.name),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: const Text(
                              " Sign up.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                    // transitioning to signing up
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
