import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoBackButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          primary: Colors.black,
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back),
        label: const Text(
          'Volver',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
