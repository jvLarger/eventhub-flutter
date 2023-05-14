import 'package:flutter/material.dart';

class EventHubBody extends StatefulWidget {
  final Widget child;
  const EventHubBody({super.key, required this.child});

  @override
  State<EventHubBody> createState() => _EventHubBodyState();
}

class _EventHubBodyState extends State<EventHubBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: widget.child,
      ),
    );
  }
}
