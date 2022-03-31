import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

class GoToEditProfileButton extends StatelessWidget {
  const GoToEditProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){},
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(25.0)),
        splashColor: Colors.white30,
        child: Ink(
          width: MediaQuery.of(context).size.width * 0.3975,
          height: 47.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(25.0)),
            color: primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Actualizar', style: TextStyle(fontSize: 14, color: Colors.white)),
              FaIcon(FontAwesomeIcons.pen, size: 18, color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }
}
