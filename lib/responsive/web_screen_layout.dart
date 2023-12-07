import 'package:flutter/material.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({required this.navigationShell, Key? key}) : super(key: key);

  final dynamic navigationShell;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const Color grey = Colors.grey;
    return Scaffold(
      body: navigationShell,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        centerTitle: false,
        title: Image.asset(
          'assets/logo.png',
          color: theme.colorScheme.primary,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () => _onTap(context, 0),
            icon: Icon(
              Icons.home,
              color: navigationShell.currentIndex == 0 ? theme.colorScheme.primary : grey,
            ),
          ),
          IconButton(
            onPressed: () => _onTap(context, 1),
            icon: Icon(
              Icons.search,
              color: navigationShell.currentIndex == 1 ? theme.colorScheme.primary : grey,
            ),
          ),
          IconButton(
            onPressed: () => _onTap(context, 2),
            icon: Icon(
              Icons.add_a_photo,
              color: navigationShell.currentIndex == 2 ? theme.colorScheme.primary : grey,
            ),
          ),
          IconButton(
            onPressed: () => _onTap(context, 3),
            icon: Icon(
              Icons.star,
              color: navigationShell.currentIndex == 3 ? theme.colorScheme.primary : grey,
            ),
          ),
          IconButton(
            onPressed: () => _onTap(context, 4),
            icon: Icon(
              Icons.person,
              color: navigationShell.currentIndex == 4 ? theme.colorScheme.primary : grey,
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
