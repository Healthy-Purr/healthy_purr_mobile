import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:page_transition/page_transition.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  type: PageTransitionType.rightToLeft,
                  child: const RegisterView()
              )
          );
        },
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: SizedBox(
          width: 250,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: const Color(0xffE7558F)),
                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
            padding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: const Center(
              child: Text(
                'Regístrate',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color(0xffE7558F),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
