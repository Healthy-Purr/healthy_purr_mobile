import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

class CatDiseasesContainer extends StatefulWidget {
  final List<Map<String, String>> diseases;
  const CatDiseasesContainer({required this.diseases, Key? key}) : super(key: key);

  @override
  _CatDiseasesContainerState createState() => _CatDiseasesContainerState();
}

class _CatDiseasesContainerState extends State<CatDiseasesContainer> {
  @override
  Widget build(BuildContext context) {

    final parentSize = MediaQuery.of(context).size;

    return Container(
      height: parentSize.height, width: parentSize.width / 2.5,
      decoration: BoxDecoration(
          color: diseasesContainerColor,
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
              left: 8, top: 8,
              child: Text('Enfermedades', style: TextStyle(color: Colors.white),)
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.only(top: 15.0),
              margin: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 10),
              child: widget.diseases.isNotEmpty ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.diseases.length,
                  itemBuilder: (context, index) {
                    return Text('- ${widget.diseases[index]["name"]}',
                        style: const TextStyle(color: Colors.white));
                  }
              ) : const Center(child: Text('Tu gatito no tiene enfermedades',
                  style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
