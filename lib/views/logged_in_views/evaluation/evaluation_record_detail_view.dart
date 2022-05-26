import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluated_food.dart';
import 'package:healthy_purr_mobile_app/models/entities/evaluation_result.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/multi_tween/multi_tween.dart';
import 'package:simple_animations/stateless_animation/mirror_animation.dart';

import '../../../utils/constants/constants.dart';
import '../../../utils/widgets/evaluation/evaluation_circular_charts.dart';
import '../../../view_models/cat_view_models/cat_list_view_model.dart';
import '../../../view_models/cat_view_models/cat_view_model.dart';

class EvaluationRecordDetailView extends StatefulWidget {
  final EvaluationResult evaluationResult;
  final EvaluatedFood evaluatedFood;
  final ImageProvider image;
  const EvaluationRecordDetailView({required this.evaluationResult, required this.evaluatedFood, required this.image,
    Key? key}) : super(key: key);

  @override
  _EvaluationRecordDetailViewState createState() => _EvaluationRecordDetailViewState();
}

enum ContainerColors {first, second}

class _EvaluationRecordDetailViewState extends State<EvaluationRecordDetailView> {

  List<double> evaluationData = [];
  double progressValue = 50;
  int index = 0;
  CatViewModel? selectedCat;

  @override
  void initState() {
    evaluationData = [widget.evaluatedFood.protein! * 100, widget.evaluatedFood.fat! * 100, widget.evaluatedFood.moisture! * 100,
      widget.evaluatedFood.fiber! * 100, widget.evaluatedFood.calcium! * 100, widget.evaluatedFood.phosphorus! * 100];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    final tween = MultiTween<ContainerColors>()
      ..add(ContainerColors.first, ColorTween(begin: complementaryColor, end: secondaryColor), const Duration(seconds: 3))
      ..add(ContainerColors.second, ColorTween(begin: secondaryColor, end: complementaryColor), const Duration(seconds: 3));

    try{
      selectedCat = Provider.of<CatListViewModel>(context).getCats().where((element) => element.catId == widget.evaluationResult.catId).first;
    }
    catch(exception){
      selectedCat = null;
    }

    if(selectedCat != null){
      index = Provider.of<CatListViewModel>(context).getCats().indexOf(selectedCat!);
    }

    String description = widget.evaluationResult.description!;

    if(description.contains(":zenpan")){
      description = description.replaceAll(":zenpan", "");
    }

    return Scaffold(
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
              top: MediaQuery.of(context).viewPadding.top + 10, //logo size
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
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              height: (screenSize.height/3),
                              width: screenSize.width * 0.92,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: widget.image,
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
                    top: 25, left: 20,
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 25,
                      child: InkWell(
                        child: const Icon(Icons.arrow_back_ios_rounded, size: 24.0, color: Colors.white,),
                        onTap: ()=> Navigator.pop(context),
                      ),
                    ),
                  ),
                  ///CAT INFORMATION
                  Positioned(
                      top: (screenSize.height - MediaQuery.of(context).viewPadding.top - 40) / 2.5, bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
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
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(description, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text('Ubicación: ', style: TextStyle(fontSize: 10,),),
                                            Text(widget.evaluationResult.location!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(DateFormat('dd/MM/yyyy').format(widget.evaluationResult.createdAt!), style: TextStyle(fontSize: 12, color: Colors.grey),),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(CupertinoIcons.clock, size: 10, color: Colors.grey,),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(DateFormat('HH:mm').format(widget.evaluationResult.createdAt!), style: TextStyle(fontSize: 12, color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('assets/images/cat_4.png', width: 120,),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: screenSize.width * 0.45,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Resultado',
                                          style: TextStyle(
                                            fontSize: 13.0, fontWeight: FontWeight.bold,
                                          ), textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        widget.evaluationResult.accuracyRate! < 0.5 ?
                                        const Text('Esta comida no es el ideal para tu gatito.',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ), textAlign: TextAlign.start,
                                        ) :
                                        const Text('Esta comida es excelente para tu gatito.',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ), textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: CircleAvatar(
                                      backgroundColor: widget.evaluationResult.accuracyRate! < 0.5 ? evaluationOption : addCatScheduleButtonColor,
                                      child: Text((widget.evaluationResult.accuracyRate! * 100).toStringAsFixed(1) + '%', style: TextStyle(fontSize: 25, color: Colors.white),),
                                      maxRadius: 40,
                                      minRadius: 25,
                                    ),
                                  ),

                                ],
                              ),
                              const SizedBox(height: 20.0),
                              const Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: Text('Análisis', style: TextStyle(fontSize: 12),),
                              ),
                              const SizedBox(height: 10.0),
                              SizedBox(
                                width: screenSize.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    EvaluationCircularCharts(data: evaluationData,),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 25.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Gato Evaluado', style: TextStyle(fontSize: 12),),
                                    const SizedBox(height: 15.0),
                                    //:zenpan
                                    widget.evaluationResult.description!.contains(':zenpan') ?
                                    Container(
                                      margin: const EdgeInsets.only(left: 10, right: 10 , bottom: 20),
                                      height: 80,
                                      width: screenSize.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(25.0)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 6),
                                            )
                                          ]),
                                      child: const Center(
                                        child: Text('Resultado de evaluación general'),
                                      ),
                                    ): selectedCat != null ?
                                    Container(
                                      margin: const EdgeInsets.only(left: 10, right: 10 , bottom: 20),
                                      height: 80,
                                      width: screenSize.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(25.0)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 6),
                                            )
                                          ]),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25.0),
                                        child: Row(
                                            children: [
                                              Container(
                                                height: 125,
                                                width: 115,
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(20.0)),
                                                  image: DecorationImage(
                                                    image: Provider.of<CatListViewModel>(context).getCatsImages()[index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 5, left: 25),
                                                    child: Text(selectedCat!.name!,
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16)),
                                                  ),
                                                ],
                                              )
                                            ]
                                        ),
                                      ),
                                    ) :
                                    Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10 , bottom: 20),
                                        height: 80,
                                        width: screenSize.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(Radius.circular(25.0)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                spreadRadius: 5,
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              )
                                            ]),
                                      child: const Center(
                                        child: Text('El gato no se encuentra en su lista', style: TextStyle(fontSize: 12, color: Colors.grey),),
                                      )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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