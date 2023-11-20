import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/utils/global_variables.dart';
import '../utils/colors.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({required this.navigationShell, Key? key})
      : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset(
          'assets/logo.png',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () => _onTap(context, 0),
            icon: Icon(
              Icons.home,
              color: navigationShell.currentIndex == 0
                  ? primaryColor
                  : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _onTap(context, 1),
            icon: Icon(
              Icons.search,
              color: navigationShell.currentIndex == 1
                  ? primaryColor
                  : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _onTap(context, 2),
            icon: Icon(
              Icons.add_a_photo,
              color: navigationShell.currentIndex == 2
                  ? primaryColor
                  : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _onTap(context, 3),
            icon: Icon(
              Icons.star,
              color: navigationShell.currentIndex == 3
                  ? primaryColor
                  : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _onTap(context, 4),
            icon: Icon(
              Icons.person,
              color: navigationShell.currentIndex == 4
                  ? primaryColor
                  : secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
