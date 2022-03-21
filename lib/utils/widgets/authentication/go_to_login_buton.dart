import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

class GoToLoginButton extends StatelessWidget {
  final VoidCallback goToLoginForm;
  const GoToLoginButton({required this.goToLoginForm,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    complementaryColor,
                    secondaryColor,
                  ],
                  stops: [0.05, 1],
                ),
              ),
            ),
          ),
          Ink(
            width: 250,
            child: TextButton(
              onPressed: goToLoginForm,
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: Text('Iniciar Sesión',
                  style: GoogleFonts.raleway()),
            ),
          ),
        ],
      ),
    );
  }
}
