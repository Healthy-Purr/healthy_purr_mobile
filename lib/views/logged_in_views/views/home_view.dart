import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Lista de Gatos',
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold
            ),
          ),
          CatList(),
          Text(
            'Horario de Comidas',
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold
            ),
          ),
          //ScheduleCard()
        ].map((children) => Padding(padding: const EdgeInsets.only(bottom: 40),
            child: children)).toList(),
      ),
    );
  }
}
