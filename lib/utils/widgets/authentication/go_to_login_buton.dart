import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

class GoToLoginButton extends StatelessWidget {
  final VoidCallback goToLoginForm;
  const GoToLoginButton({required this.goToLoginForm,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: goToLoginForm,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: const EdgeInsets.symmetric(vertical: 0),
          maximumSize: const Size(250, 50),
          primary: Colors.transparent,
          elevation: 0
      ),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              complementaryColor,
              secondaryColor,
            ],
            stops: [0.05, 1],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            'Iniciar Sesión',
            style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
