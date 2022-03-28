import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheckingMessageView extends StatefulWidget {
  final String text;
  const CheckingMessageView({Key? key, required this.text}) : super(key: key);

  @override
  _CheckingMessageViewState createState() => _CheckingMessageViewState();
}

enum ContainerColors {first, second}

class _CheckingMessageViewState extends State<CheckingMessageView> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: screenSize.width/1.2,
          height: 80.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 4),
                )
              ]
          ),
        ),
        Positioned(
          left: 60.0,
          child: Image.asset('assets/images/cat_2_cropped.png', scale: 1.6,),
        ),
        Positioned(
          top: 15.0,
          left: 180.0,
          child: SizedBox(
            width: screenSize.width/2.2,
            child: Text(widget.text, style: const TextStyle(fontSize: 12),),
          ),
        )
      ],
    );
  }

}