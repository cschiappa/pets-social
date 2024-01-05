import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/features/profile/controller/profile_provider.dart';
import 'package:pets_social/features/user/controller/user_provider.dart';

class ResponsiveLayout extends ConsumerStatefulWidget {
  final Widget mobile;
  final Widget web;
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  // static bool isTablet(BuildContext context) =>
  //     MediaQuery.of(context).size.width < 1100 &&
  //     MediaQuery.of(context).size.width >= 850;
  static bool isWeb(BuildContext context) => MediaQuery.of(context).size.width >= 600;
  const ResponsiveLayout({
    Key? key,
    required this.web,
    required this.mobile,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends ConsumerState<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    await ref.read(userProvider.notifier).refreshProfile();
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
