import 'package:flutter/material.dart';

class EventHubBadge extends StatelessWidget {
  const EventHubBadge({
    super.key,
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: color,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
            fontFamily: 'Urbanist',
          ),
        ),
      ),
    );
  }
}
