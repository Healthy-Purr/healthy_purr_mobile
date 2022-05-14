import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_view_model.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    Provider.of<EvaluationViewModel>(context, listen: false).determineLocation();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;


    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lista de Gatos',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          const HorizontalCatList(),
          SizedBox(
            height: screenSize.height * 0.05,
          ),
          const Text(
            'Horario de Comidas',
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          const ScheduleCard()
        ],
      ),
    );
  }
}
