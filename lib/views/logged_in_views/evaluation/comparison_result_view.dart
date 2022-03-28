import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_view_model.dart';
import 'package:provider/provider.dart';
import '../../../utils/constants/constants.dart';

class ComparisonListView extends StatefulWidget {

  const ComparisonListView({Key? key}) : super(key: key);

  @override
  _ComparisonListViewState createState() => _ComparisonListViewState();
}

enum ContainerColors {first, second}

class _ComparisonListViewState extends State<ComparisonListView> {

  List<String> evaluationList = [];

  @override
  void initState() {
    evaluationList = Provider.of<EvaluationViewModel>(context, listen: false).getEvaluations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<EvaluationViewModel>(context, listen: false).clearEvaluationList();
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
                left: 25, top: MediaQuery.of(context).viewPadding.top + 45,
                bottom: 5, right: 25,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: evaluationList.length,
                    itemBuilder: (context, index) {

                      final selectedEvaluation = evaluationList[index];

                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(context,
                          //     PageTransition(
                          //         duration: const Duration(milliseconds: 200),
                          //         reverseDuration: const Duration(milliseconds: 200),
                          //         type: PageTransitionType.rightToLeft,
                          //         child: CatProfileView(
                          //             catImage: selectedCatImage,
                          //             cat: selectedCat
                          //         )
                          //     )
                          // );
                          // Provider.of<CatListViewModel>(context, listen: false).selectedCat = selectedCat;
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
                                                  text: selectedEvaluation,
                                                  style:
                                                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                            ])),
                                            selectedEvaluation[index].contains('No')?
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
                                const CircleAvatar(
                                  backgroundColor: addCatScheduleButtonColor,
                                  child: Text('90%', style: TextStyle(fontSize: 25, color: Colors.white),),
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
              )

            ],
          ),
        ),
      ),
    );

  }
}