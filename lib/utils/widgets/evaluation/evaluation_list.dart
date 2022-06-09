import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluated_food.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluation_result.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_record_view_model.dart';
import 'package:healthy_purr_mobile_app/views/logged_in_views/evaluation/evaluation_record_detail_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';

class EvaluationList extends StatefulWidget {

  const EvaluationList({Key? key}) : super(key: key);

  @override
  _EvaluationListState createState() => _EvaluationListState();
}

enum ContainerColors {first, second}

class _EvaluationListState extends State<EvaluationList> {

  var evaluationList = [];
  var evaluatedFoodList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    evaluationList = Provider.of<EvaluationRecordViewModel>(context).getEvaluations();

    evaluatedFoodList = Provider.of<EvaluationRecordViewModel>(context).getEvaluatedFeed();

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: evaluationList.isNotEmpty ? ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: evaluationList.length,
          itemBuilder: (context, index) {

            final selectedEvaluation = evaluationList[index];
            final selectedEvaluatedFood = evaluatedFoodList[index];

            String description = selectedEvaluation.description!;

            if(description.contains(":zenpan")){
              description = description.replaceAll(":zenpan", "");
            }

            return GestureDetector(
              onTap: () {
                Provider.of<EvaluationRecordViewModel>(context, listen: false).getImageProvider(selectedEvaluation.evaluationResultId!).then((value){
                  Navigator.push(context,
                      PageTransition(
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                          type: PageTransitionType.rightToLeft,
                          child: EvaluationRecordDetailView(
                              image: value,
                              evaluationResult: selectedEvaluation, evaluatedFood: selectedEvaluatedFood,
                          )
                      )
                  );
                });

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
                            child: Text(description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text.rich(TextSpan(children: [
                                    TextSpan(text: 'Resultado: ', style: TextStyle(fontSize: 12)),
                                    TextSpan(
                                        text: 'Recomendado',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ])),
                                ],
                              ),
                              Row(
                                children: [
                                  Text.rich(TextSpan(children: [
                                    const TextSpan(text: 'Ubicación: ', style: TextStyle(fontSize: 12)),
                                    TextSpan(
                                        text: selectedEvaluation.location!,
                                        style:
                                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ])),
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
                      const SizedBox(
                        width: 10,
                      )
                    ]
                ),
              ),
            );
          }) : Stack(
        alignment: AlignmentDirectional.center,
        children: [
          FaIcon(FontAwesomeIcons.file, color: primaryColor.withOpacity(0.2), size: 60,),
          const Text('No tiene evaluaciones guardadas', style: TextStyle(color: Colors.grey),),
        ],
      ),
    );

  }
}