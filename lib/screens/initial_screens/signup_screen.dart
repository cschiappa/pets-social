import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/resources/auth_methods.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/utils/utils.dart';
import '../../features/app_router.dart';
import '../../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  //SELECT IMAGE
  void selectImage() async {
    Uint8List im;
    (im, _, _, _) = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  //SIGNUP
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      if (!mounted) return;
      showSnackBar(res, context);
    } else {
      if (!mounted) return;

      context.goNamed(AppRouter.feedScreen.name);
    }
  }

  //NAVIGATE TO LOGIN
  void navigateToLogin() {
    context.goNamed(AppRouter.login.name);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Container(
            padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(flex: 2, fit: FlexFit.loose, child: Container()),
                  //LOGO
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                    child: Image.asset(
                      'assets/logo.png',
                      color: theme.colorScheme.primary,
                      height: 56,
                    ),
                  ),
                  const SizedBox(height: 44),
                  //SELECT IMAGE
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg',
                              )),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  //USERNAME
                  TextFieldInput(
                    labelText: 'Enter your username',
                    textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  //EMAIL
                  TextFieldInput(
                    labelText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  //PASSWORD
                  TextFieldInput(
                    labelText: 'Enter your password',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    labelText: 'Enter your bio',
                    textInputType: TextInputType.text,
                    textEditingController: _bioController,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  //SIGN IN BUTTON
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: ShapeDecoration(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: theme.colorScheme.secondary),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : const Text('Sign up'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(flex: 2, fit: FlexFit.loose, child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: const Text("Already have an account?"),
                      ),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: const Text(
                            " Login.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
