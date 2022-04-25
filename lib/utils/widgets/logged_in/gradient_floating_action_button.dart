import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthy_purr_mobile_app/services/camera_service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../views/logged_in_views/camera/camera_view.dart';

class GradientFloatingActionButton extends StatefulWidget {
  final VoidCallback onTap;
  final double height;
  final double width;
  const GradientFloatingActionButton({Key? key, required this.onTap, required this.height, required this.width}) : super(key: key);

  @override
  _GradientFloatingActionButtonState createState() => _GradientFloatingActionButtonState();
}

class _GradientFloatingActionButtonState extends State<GradientFloatingActionButton>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(18),
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              complementaryColor.withOpacity(0.9),
              secondaryColor,
            ],
            stops: [0.001, 0.7],
          ),
          shape: CircleBorder(),
        ),
        child: SvgPicture.asset(
          'assets/images/camera_icon.svg',
        ),
      ),
    );
  }
}
