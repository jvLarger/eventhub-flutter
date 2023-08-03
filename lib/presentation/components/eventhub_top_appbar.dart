import 'package:flutter/material.dart';

class EventHubTopAppbar extends StatelessWidget {
  const EventHubTopAppbar({
    super.key,
    required this.title,
    this.tabBar,
  });

  final String title;
  final TabBar? tabBar;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: tabBar,
    );
  }
}
