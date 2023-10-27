import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/utils/colors.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Give Some Feedback'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              'Once you press the feedback button, please navigate to the page that is giving you any problem. You can use the drawing pen to specify the exact spot.'),
          const Text(
              "If you don't have a specific page you want to talk about, you can just write down whatever you want to share with us. Thank you!"),
          TextButton(
              onPressed: () {
                BetterFeedback.of(context).show((UserFeedback feedback) {
                  // Do something with the feedback
                });
              },
              child: const Text('Give Feedback'))
        ],
      ),
    );
  }
}
