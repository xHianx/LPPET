import 'package:flutter/material.dart';
import 'package:lppet/constants.dart';

class MyInputField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;

  const MyInputField({required this.hint, super.key, required this.controller});

  @override
  MyInputFieldState createState() => MyInputFieldState();
}

class MyInputFieldState extends State<MyInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: textColor.withOpacity(0.7),
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
