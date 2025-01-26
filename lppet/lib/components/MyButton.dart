import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color labelColor;
  final double cornerRadius;
  final double shadowIntensity;
  final EdgeInsetsGeometry margin;

  const MyButton({
    required this.label,
    required this.onTap,
    this.buttonColor = Colors.teal,
    this.labelColor = Colors.black,
    this.cornerRadius = 12.0,
    this.shadowIntensity = 4.0,
    this.margin = const EdgeInsets.all(16.0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(cornerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: shadowIntensity,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }
}
