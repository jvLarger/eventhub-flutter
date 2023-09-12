import 'package:flutter/material.dart';

class EventHubBadge extends StatelessWidget {
  const EventHubBadge({
    super.key,
    required this.color,
    required this.label,
    this.fontSize,
    this.filled,
    this.onTap,
  });

  final Color color;
  final String label;
  final double? fontSize;
  final bool? filled;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: color,
          ),
          color: filled != null && filled! ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: filled != null && filled! ? Colors.white : color,
              fontSize: fontSize ?? 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
      ),
    );
  }
}
