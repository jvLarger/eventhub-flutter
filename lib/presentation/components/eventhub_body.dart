import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class EventHubBody extends StatefulWidget {
  final Widget child;
  final Widget? topWidget;
  const EventHubBody({
    super.key,
    required this.child,
    this.topWidget,
  });

  @override
  State<EventHubBody> createState() => _EventHubBodyState();
}

class _EventHubBodyState extends State<EventHubBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  bottomNavigationBar: Padding(
          padding:
              EdgeInsets.symmetric(vertical: 10, horizontal: defaultPadding),
          child: InkWell(
            onTap: () {
              print('called on tap');
            },
            child: SizedBox(
              height: kToolbarHeight,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Continuar"),
                  ],
                ),
              ),
            ),
          )),*/
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
