import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

class GoBackToProfileButton extends StatelessWidget {
  const GoBackToProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: InkWell(
          splashColor: Colors.pink[200],
          onTap: (){
            Navigator.pop(context);
          },
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: complementaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(20.0))
            ),
            child: const Center(
              child: Text(
                'Volver',
                style: TextStyle(
                  fontSize: 18.0,
                  color: complementaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
