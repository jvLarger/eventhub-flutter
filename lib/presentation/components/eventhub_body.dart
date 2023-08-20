import 'package:flutter/material.dart';

class EventHubBody extends StatefulWidget {
  final Widget child;
  final Widget? topWidget;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final bool? isLoading;
  const EventHubBody({
    super.key,
    required this.child,
    this.topWidget,
    this.bottomNavigationBar,
    this.appBar,
    this.isLoading,
  });

  @override
  State<EventHubBody> createState() => _EventHubBodyState();
}

class _EventHubBodyState extends State<EventHubBody> {
  @override
  Widget build(BuildContext context) {
    return widget.isLoading != null && widget.isLoading!
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
