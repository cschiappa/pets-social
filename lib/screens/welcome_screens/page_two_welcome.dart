import 'package:flutter/material.dart';

class WelcomePageTwo extends StatelessWidget {
  const WelcomePageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[300],
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                'When you first create your account you will automatically create your first pet profile.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              'assets/cat_id.png',
              scale: 1.5,
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                "But don't worry...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Text(
                'Once you are inside, you will be able to create more profiles for your other pets!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
