import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/extensions.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('MobileScreenLayout'));

  final Widget navigationShell;

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      // body: PageView(
      //   //if I want to remove slide to side, uncommment bellow
      //   physics: const NeverScrollableScrollPhysics(),
      //   controller: pageController,
      //   onPageChanged: onPageChanged,
      //   children: homeScreenItems,
      // ),
      body: widget.navigationShell,
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _selectedIndex(context),
        onTap: onTap,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
            ),
            label: '',
            backgroundColor: theme.colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.search,
            ),
            label: '',
            backgroundColor: theme.colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.add_circle,
            ),
            label: '',
            backgroundColor: theme.colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.star,
            ),
            label: '',
            backgroundColor: theme.colorScheme.primary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.person,
            ),
            label: '',
            backgroundColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location();
    if (location.startsWith('/feed')) {
      return 0;
    }
    if (location.startsWith('/search')) {
      return 1;
    }
    if (location.startsWith('/addpost')) {
      return 2;
    }
    if (location.startsWith('/prizes')) {
      return 3;
    }
    if (location.startsWith('/profile')) {
      return 4;
    }
    return 0;
  }

  void onTap(int value) {
    switch (value) {
      case 0:
        return context.go('/feed');
      case 1:
        return context.go('/search');
      case 2:
        return context.go('/addpost');
      case 3:
        return context.go('/prizes');
      case 4:
        return context.go('/profile');
      default:
        return context.go('/feed');
    }
  }
}
