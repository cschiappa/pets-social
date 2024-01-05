import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({required this.navigationShell, Key? key}) : super(key: key ?? const ValueKey<String>('MobileScreenLayout'));

  final StatefulNavigationShell navigationShell;

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: CupertinoTabBar(
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
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}
