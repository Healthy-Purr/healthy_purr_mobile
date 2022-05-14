import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

class CatAllergiesContainer extends StatefulWidget {
  final List<Map<String, String>> allergies;
  const CatAllergiesContainer({required this.allergies, Key? key}) : super(key: key);

  @override
  _CatAllergiesContainerState createState() => _CatAllergiesContainerState();
}

class _CatAllergiesContainerState extends State<CatAllergiesContainer> {
  @override
  Widget build(BuildContext context) {

    final parentSize = MediaQuery.of(context).size;

    return Container(
      height: parentSize.height, width: parentSize.width / 2.5,
      decoration: BoxDecoration(
        color: allergiesContainerColor,
        borderRadius: const BorderRadius.all(
            Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 3),
          )
        ]
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0, right: 0,
            child: Transform.rotate(
              angle: 3.1416/180*340,
              child: Image.asset(pawAsset,
                  height: 80,
                  width: 80,
                  color: Colors.white.withOpacity(0.2),
                  fit: BoxFit.fill
              ),
            )
          ),
          const Positioned(
            left: 15, top: 15,
            child: Text('Alergias', style: TextStyle(fontWeight: FontWeight.bold),)
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.only(top: 15.0),
              margin: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 10),
              child: widget.allergies.isNotEmpty ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.allergies.length,
                itemBuilder: (context, index) {
                  return Text('- ${widget.allergies[index]["name"]}');
                }
              ) : const Center(child: Text('Tu gatito no tiene alergias', style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center)),
            ),
          ),
        ],
      ),
    );
  }
}
