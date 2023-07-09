import 'package:flutter/material.dart';

class EventHubBody extends StatefulWidget {
  final Widget child;
  final Widget? topWidget;
  final Widget? bottomNavigationBar;
  const EventHubBody({
    super.key,
    required this.child,
    this.topWidget,
    this.bottomNavigationBar,
  });

  @override
  State<EventHubBody> createState() => _EventHubBodyState();
}

class _EventHubBodyState extends State<EventHubBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.topWidget ?? const SizedBox(),
            widget.child,
          ],
        ),
      ),
    );
  }
}
