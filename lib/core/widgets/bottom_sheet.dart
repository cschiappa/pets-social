import 'package:flutter/material.dart';

class CustomBottomSheet {
  static void show({
    required BuildContext context,
    required List<Widget> listWidget,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(30),
          child: ListView(
            shrinkWrap: true,
            children: listWidget,
          ),
        );
      },
    );
  }
}
