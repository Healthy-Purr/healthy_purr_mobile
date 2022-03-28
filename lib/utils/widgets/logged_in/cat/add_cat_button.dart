import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:page_transition/page_transition.dart';

class AddCatButton extends StatelessWidget {
  const AddCatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, PageTransition(
            duration: const Duration(milliseconds: 200),
            reverseDuration: const Duration(milliseconds: 200),
            type: PageTransitionType.rightToLeft,
            child: const CatRegisterView()
        ));
      },
      child: Container(
        height: 65, width: 85,
        decoration: const BoxDecoration(
          color: primaryColor,
          boxShadow: [
            BoxShadow(
                color: Color(0xFFE5E4E4),
                spreadRadius: 1,
                blurRadius: 0.5,
                offset: Offset(0, 1)
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
            topRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0)
          ),
        ),
        child: const Center(
          child: FaIcon(
            FontAwesomeIcons.plus,
            color: Colors.white,
            size: 45,
          )
        ),
      ),
    );
  }
}
