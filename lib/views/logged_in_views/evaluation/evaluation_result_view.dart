import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/dtos/evaluation_dto.dart';
import 'package:healthy_purr_mobile_app/models/entities/cat_food_analysis.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:io';

import '../../../utils/widgets/evaluation/evaluation_circular_charts.dart';

class EvaluationResultView extends StatefulWidget {
  final CatFoodAnalysis evaluationResult;
  final File image;
  final int index;
  const EvaluationResultView({required this.evaluationResult, required this.image, required this.index,
    Key? key}) : super(key: key);

  @override
  _EvaluationResultViewState createState() => _EvaluationResultViewState();
}

enum ContainerColors {first, second}

class _EvaluationResultViewState extends State<EvaluationResultView> {

  List<double> evaluationData = [];
  double progressValue = 50;

  late var _future;

  @override
  void initState() {
    evaluationData = [widget.evaluationResult.analysis!.protein! * 100, widget.evaluationResult.analysis!.fat! * 100, widget.evaluationResult.analysis!.moisture! * 100,
      widget.evaluationResult.analysis!.fiber! * 100, widget.evaluationResult.analysis!.calcium! * 100, widget.evaluationResult.analysis!.phosphorus! * 100];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    final tween = MultiTween<ContainerColors>()
      ..add(ContainerColors.first, ColorTween(begin: complementaryColor, end: secondaryColor), const Duration(seconds: 3))
      ..add(ContainerColors.second, ColorTween(begin: secondaryColor, end: complementaryColor), const Duration(seconds: 3));

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          children: [
            Positioned(
                right: 0,
                child: Image.asset(topRightDecoration, height: 400,
                    alignment: Alignment.topLeft, fit: BoxFit.contain
                )
            ),
            Positioned(
              left: 25, top: MediaQuery.of(context).viewPadding.top,
              child: Image.asset(healthyPurrLogo, height: 35,
                  alignment: Alignment.topLeft, fit: BoxFit.contain),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 40, //logo size
              bottom: 0, right: 0, left: 0,
              child: Stack(
                children: [
                  Positioned(
                      top: 20,
                      child: MirrorAnimation<MultiTweenValues<ContainerColors>>(
                          tween: tween,
                          duration: tween.duration,
                          builder: (context, child, animation) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              height: (screenSize.height/3),
                              width: screenSize.width/1.2,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: FileImage(widget.image),
                                      fit: BoxFit.fitWidth),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      animation.get(ContainerColors.first),
                                      animation.get(ContainerColors.second),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(20.0),)
                              ),
                            );
                          }
                      )
                  ),
                  ///GO BACK BUTTON
                  Positioned(
                    top: 25, left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 35.0, color: Colors.white,),
                      onPressed: ()=> Navigator.pop(context),
                    ),
                  ),
                  ///CAT INFORMATION
                  Positioned(
                      top: (screenSize.height - MediaQuery.of(context).viewPadding.top - 40) / 2.5, bottom: 0,
                      child: Container(
                        height: (screenSize.height - MediaQuery.of(context).viewPadding.top - 40) / 2,
                        width: screenSize.width,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, -2),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(25.0),)),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: addCatScheduleButtonColor,
                                    child: Text(widget.evaluationResult.result.toStringAsFixed(1) + '%', style: TextStyle(fontSize: 25, color: Colors.white),),
                                    maxRadius: 45,
                                    minRadius: 35,
                                  ),
                                  SizedBox(
                                    width: screenSize.width/2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('Resultado',
                                          style: TextStyle(
                                            fontSize: 15.0, fontWeight: FontWeight.bold,
                                          ), textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Esta comida es compatible y recomendable para tu gatito.',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ), textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              EvaluationCircularCharts(data: evaluationData,)
                            ],
                          ),
                        ),
                      )
                  ),
                  ///ADD CAT SCHEDULE CLIP BUTTON
                  Positioned(
                    top: ((screenSize.height - MediaQuery.of(context).viewPadding.top - 40) / 2.5) - 5,
                    right: screenSize.width * 0.06,
                    child: ClipButton(
                      icon: Icons.save_rounded,
                      onTap: () {
                        //TODO: ADD FUNCTION TO ADD SCHEDULE
                      },
                      color: updateCatInformationButtonColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
}