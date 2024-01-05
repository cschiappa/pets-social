import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/features/welcome_screens/page_one_welcome.dart';
import 'package:pets_social/features/welcome_screens/page_three_welcome.dart';
import 'package:pets_social/features/welcome_screens/page_two_welcome.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              WelcomePageOne(),
              WelcomePageTwo(),
              WelcomePageThree(),
            ],
          ),
          Container(
            alignment: const Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: const Text('skip'),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const JumpingDotEffect(activeDotColor: Colors.deepPurple),
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          context.goNamed(AppRouter.signup.name);
                        },
                        child: const Text('done'),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                        },
                        child: const Text('next'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
