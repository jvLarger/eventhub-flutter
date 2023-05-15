import 'package:flutter/material.dart';

class EventHubTopAppbar extends StatelessWidget {
  const EventHubTopAppbar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}
