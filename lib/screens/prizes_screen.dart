import 'package:flutter/material.dart';
import 'package:pets_social/utils/colors.dart';

class PrizesScreen extends StatefulWidget {
  const PrizesScreen({super.key});

  @override
  State<PrizesScreen> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends State<PrizesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Hi username,'),
          ),
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.amber,
            child: Text('Notifications'),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text('Prizes'),
          )
        ],
      ),
    ));
  }
}
