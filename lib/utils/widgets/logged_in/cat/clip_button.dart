import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClipButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color color;
  const ClipButton({required this.onTap, required this.icon,
    required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 35.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8.0), bottom: Radius.circular(20.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            FaIcon(icon, color: Colors.white, size: 25.0),
          ],
        ),
      ),
    );
  }
}
