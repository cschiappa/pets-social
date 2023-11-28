import 'package:flutter/material.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobile;
  final Widget web;
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  // static bool isTablet(BuildContext context) =>
  //     MediaQuery.of(context).size.width < 1100 &&
  //     MediaQuery.of(context).size.width >= 850;
  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;
  const ResponsiveLayout({
    Key? key,
    required this.web,
    required this.mobile,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, constraints) {
      if (size.width > 600) {
        return widget.web;
      } else {
        return widget.mobile;
      }
    });
  }
}
