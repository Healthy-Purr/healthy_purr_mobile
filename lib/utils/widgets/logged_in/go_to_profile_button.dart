import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:page_transition/page_transition.dart';


class GoToProfileButton extends StatelessWidget {
  const GoToProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 40,
      width: 60,
      decoration: const BoxDecoration(
          color: Color(0xffFFD98E),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0))),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              PageTransition(
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  type: PageTransitionType.rightToLeft,
                  child: const UserProfileView()
              )
          );
        },
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0)),
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(
                  Icons.account_circle,
                  size: 35.0,
                  color: Color(0xffFFF0D2),
                ),
                SizedBox()
              ]
          ),
        ),
      ),
    );
  }
}
