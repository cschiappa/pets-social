import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:feedback/src/better_feedback.dart';

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
      body: Container(
        color: Colors.deepPurple[800],
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Once you press the feedback button, please navigate to the page that is giving you any problem. You can use the drawing pen to specify the exact spot.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 10,
              ),
              const Text(
                  "If you don't have a specific page you want to talk about, you can just write down whatever you want to share with us. Thank you!",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  BetterFeedback.of(context).show((UserFeedback feedback) {
                    // Do something with the feedback
                  });
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: pinkColor),
                  child: const Text(
                    'Send Feedback',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
