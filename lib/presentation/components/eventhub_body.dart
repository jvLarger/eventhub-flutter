import 'package:flutter/material.dart';

class EventHubBody extends StatefulWidget {
  final Widget child;
  final Widget? topWidget;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  const EventHubBody({
    super.key,
    required this.child,
    this.topWidget,
    this.bottomNavigationBar,
    this.appBar,
  });

  @override
  State<EventHubBody> createState() => _EventHubBodyState();
}

class _EventHubBodyState extends State<EventHubBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: widget.appBar,
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
