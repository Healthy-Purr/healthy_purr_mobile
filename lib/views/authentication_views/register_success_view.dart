import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/constants.dart';


class RegisterSuccessView extends StatefulWidget {
  const RegisterSuccessView({Key? key}) : super(key: key);

  @override
  RegisterSuccessViewState createState() => RegisterSuccessViewState();
}


class RegisterSuccessViewState extends State<RegisterSuccessView> with TickerProviderStateMixin {

  late AnimationController scaleController = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    double circleSize = 150;
    double iconSize = 150;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              right: -50,
              child: Image.asset('assets/images/top-right_decoration.png',
                  height: 350, alignment: Alignment.topLeft, fit: BoxFit.contain),
            ),
             Positioned(
              top: 80, bottom: 40, right: 20, left: 20,
              child: Container(
                height: size.height * 0.8,
                width: size.width * 0.92,
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo_color.png', height: 50,),
                    Text('Bienvenido', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    Stack(
                      children: [
                        Center(
                          child: ScaleTransition(
                            scale: scaleAnimation,
                            child: Container(
                              height: circleSize,
                              width: circleSize,
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        SizeTransition(
                          sizeFactor: checkAnimation,
                          axis: Axis.horizontal,
                          axisAlignment: -1,
                          child: Center(
                            child: Icon(Icons.check_rounded, color: Colors.white, size: iconSize),
                          ),
                        ),
                      ],
                    ),
                    const Text('Disfruta de la aplicación!', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                        child: Stack(
                          alignment: Alignment.center,
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
                              child: TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  //_saveForm();
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: Center(
                                  child: Text('Continuar',
                                      style: GoogleFonts.comfortaa()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}