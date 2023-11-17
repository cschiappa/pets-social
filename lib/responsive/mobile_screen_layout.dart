import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/utils/global_variables.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('MobileScreenLayout'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: PageView(
      //   //if I want to remove slide to side, uncommment bellow
      //   physics: const NeverScrollableScrollPhysics(),
      //   controller: pageController,
      //   onPageChanged: onPageChanged,
      //   children: homeScreenItems,
      // ),
      body: navigationShell,
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              //color: _page == 0 ? pinkColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              //color: _page == 1 ? pinkColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              //color: _page == 2 ? pinkColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              //color: _page == 3 ? pinkColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              //color: _page == 4 ? pinkColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
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
