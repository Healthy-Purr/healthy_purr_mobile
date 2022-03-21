import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

class GradientFloatingActionButton extends StatefulWidget {
  const GradientFloatingActionButton({Key? key}) : super(key: key);

  @override
  _GradientFloatingActionButtonState createState() => _GradientFloatingActionButtonState();
}

class _GradientFloatingActionButtonState extends State<GradientFloatingActionButton>{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Ink(
        height: 75,
        width: 75,
        decoration: const ShapeDecoration(
          gradient: LinearGradient(
            colors: [
              complementaryColor,
              secondaryColor,
            ],
            stops: [0.05, 1],
          ),
          shape: CircleBorder(),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Ink(
            width: 15, height: 15,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/camera_icon.png'))
            ),
            child: InkWell(
              onTap: () {
                //TODO: ADD CAMERA VIEW
              },
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            ),
          ),
        ),
      ),
    );
  }
}
