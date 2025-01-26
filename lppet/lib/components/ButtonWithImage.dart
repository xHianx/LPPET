import 'package:flutter/material.dart';

class ButtonWithImage extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const ButtonWithImage({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white70,
          foregroundColor: Colors.black,
          minimumSize: const Size(300, 50), // Puedes ajustar el tamaño del botón
        ),
        icon: Image.asset(imagePath, width: 24, height: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: 'LexendDeca',
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}