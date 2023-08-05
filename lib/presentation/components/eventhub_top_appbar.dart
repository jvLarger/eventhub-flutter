import 'package:flutter/material.dart';

class EventHubTopAppbar extends StatelessWidget {
  const EventHubTopAppbar({
    super.key,
    required this.title,
    this.tabBar,
    this.actions,
  });

  final String title;
  final TabBar? tabBar;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: tabBar,
      actions: actions,
    );
  }
}
