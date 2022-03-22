import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatDetailsCard extends StatelessWidget {
  final FaIcon icon;
  final String attribute;
  final String text;
  const CatDetailsCard({Key? key, required this.icon, required this.attribute,
    required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      height: 65, width: 65,
      color: Colors.transparent,
      child: Column(
        children: [
          icon,
          Text(attribute, style: const TextStyle(color: Colors.black)),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black) )
        ],
      ),
    );
  }
}
