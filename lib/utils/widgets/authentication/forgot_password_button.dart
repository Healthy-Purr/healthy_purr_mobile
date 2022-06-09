import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.transparent,
        ),
        onPressed: () {},
        child: const Text(
          'Olvidé mi contraseña',
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 15.0,
            fontWeight: FontWeight.w300,
            color: Color(0xffFC5155),
          ),
        ),
      ),
    );
  }
}
