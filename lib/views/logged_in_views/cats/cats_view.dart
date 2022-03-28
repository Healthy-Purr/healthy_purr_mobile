import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
class CatsView extends StatefulWidget {
  const CatsView({Key? key}) : super(key: key);

  @override
  State<CatsView> createState() => _CatsViewState();
}

class _CatsViewState extends State<CatsView> {

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Mis Gatos',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: const [
                VerticalCatList(),
                Positioned(
                    bottom: 0, right: 0,
                    child: AddCatButton()
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
