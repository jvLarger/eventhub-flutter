import 'package:eventhub/utils/constants.dart';
import 'package:flutter/material.dart';

class EventHubBottomButton extends StatelessWidget {
  const EventHubBottomButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
        ),
      ),
      padding: const EdgeInsets.all(defaultPadding),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
          ],
        ),
      ),
    );
  }
}
