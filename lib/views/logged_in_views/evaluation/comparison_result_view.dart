import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/dtos/evaluation_dto.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_view_model.dart';
import 'package:healthy_purr_mobile_app/views/logged_in_views/evaluation/evaluation_result_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../models/entities/cat_food_analysis.dart';
import '../../../utils/constants/constants.dart';
import '../../../view_models/camera_view_models/camera_view_model.dart';

class ComparisonListView extends StatefulWidget {

  const ComparisonListView({Key? key}) : super(key: key);

  @override
  _ComparisonListViewState createState() => _ComparisonListViewState();
}

enum ContainerColors {first, second}

class _ComparisonListViewState extends State<ComparisonListView> {

  List<CatFoodAnalysis> evaluationList = [];
  List<double> finalEvaluationList = [];

  @override
  void initState() {
    evaluationList = Provider.of<EvaluationViewModel>(context, listen: false).getEvaluations();
    finalEvaluationList = Provider.of<EvaluationViewModel>(context, listen: false).getFinalEvaluationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<EvaluationViewModel>(context, listen: false).clearEvaluationList();
        Provider.of<CameraViewModel>(context, listen: false).cleanPhotos();
        return true;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Stack(
            children: [
              Positioned(
                  right: -50,
                  child: Image.asset(topRightDecoration, height: 350,
                      alignment: Alignment.topLeft, fit: BoxFit.contain
                  )
              ),
              Positioned(
                right: 25, top: MediaQuery.of(context).viewPadding.top + 10,
                child: Image.asset('assets/images/splash.png', height: 35,
                    alignment: Alignment.topLeft, fit: BoxFit.contain),
              ),
              Positioned(
                left: 25, top: MediaQuery.of(context).viewPadding.top + 45,
                bottom: 5, right: 25,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: primaryColor,
                            child: InkWell(
                              child: Icon(Icons.home, size: 25.0, color: Colors.white,),
                              onTap: (){
                                Provider.of<EvaluationViewModel>(context, listen: false).clearEvaluationList();
                                Provider.of<CameraViewModel>(context, listen: false).cleanPhotos();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text(
                            'Resultados',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.8,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: finalEvaluationList.length,
                          itemBuilder: (context, index) {

                            final selectedEvaluation = evaluationList[index];
                            final evalValue = finalEvaluationList[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    PageTransition(
                                        duration: const Duration(milliseconds: 200),
                                        reverseDuration: const Duration(milliseconds: 200),
                                        type: PageTransitionType.rightToLeft,
                                        child: EvaluationResultView(
                                          index: index,
                                          image: Provider.of<CameraViewModel>(context, listen: false).getPhotos()[index],
                                          evaluationResult: selectedEvaluation
                                        )
                                    )
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                height: 125,
                                width: 300,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(25.0)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 4),
                                      )
                                    ]),
                                child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 5, left: 25),
                                            child: Text('Opción ${index + 1}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16)),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text.rich(TextSpan(children: [
                                                    const TextSpan(text: 'Resultado: ', style: TextStyle(fontSize: 12)),
                                                    TextSpan(
                                                        text: (selectedEvaluation.result * 100).toStringAsFixed(1),
                                                        style:
                                                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                  ])),
                                                  evalValue < 0.5 ?
                                                  const Icon( CupertinoIcons.clear_circled_solid, color: evaluationOption, size: 15,) :
                                                  const Icon( CupertinoIcons.check_mark_circled_solid, color: addCatScheduleButtonColor, size: 15,)

                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: const [
                                                  Text('Dar click para revisar detalle', style: TextStyle(color: Colors.grey, fontSize: 10),),
                                                  Icon( Icons.arrow_forward_ios_sharp , color: Colors.grey, size: 10,)
                                                ],
                                              ),
                                            ]
                                                .map((children) => Padding(
                                                padding:
                                                const EdgeInsets.fromLTRB(25, 6, 0, 0),
                                                child: children))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      CircleAvatar(
                                        backgroundColor: selectedEvaluation.result < 0.5 ? evaluationOption : addCatScheduleButtonColor,
                                        child: Text((selectedEvaluation.result * 100).toStringAsFixed(1)+ '%', style: TextStyle(fontSize: 25, color: Colors.white),),
                                        maxRadius: 45,
                                        minRadius: 35,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ]
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );

  }
}