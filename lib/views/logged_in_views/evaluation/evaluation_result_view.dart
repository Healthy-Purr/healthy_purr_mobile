import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/entities/cat_food_analysis.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/camera_view_models/camera_view_model.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_view_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:io';

import '../../../utils/widgets/evaluation/evaluation_circular_charts.dart';
import '../../../view_models/evaluation_view_models/evaluation_record_view_model.dart';

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

class _EvaluationResultViewState extends State<EvaluationResultView> with TickerProviderStateMixin{

  List<double> evaluationData = [];
  double progressValue = 50;
  String name = "";
  final _formKey = GlobalKey<FormState>();

  late AnimationController scaleController = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);

  late var _future;

  @override
  void initState() {
    evaluationData = [widget.evaluationResult.analysis!.protein! * 100, widget.evaluationResult.analysis!.fat! * 100, widget.evaluationResult.analysis!.moisture! * 100,
      widget.evaluationResult.analysis!.fiber! * 100, widget.evaluationResult.analysis!.calcium! * 100, widget.evaluationResult.analysis!.phosphorus! * 100];

    super.initState();
  }

  _registerSuccess(Size size){

    double circleSize = 100;
    double iconSize = 100;

    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();

    Provider.of<EvaluationRecordViewModel>(context, listen: false).populateEvaluationResultList().whenComplete((){
      Navigator.pop(context);
    });

    showDialog(
      barrierColor: Colors.white.withOpacity(0.9),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('El registro se completó con éxito', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center,),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 300.0,
            height: 180,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: 300.0,
                    height: 180,
                    child: Stack(
                      children: [
                        Center(
                          child: ScaleTransition(
                            scale: scaleAnimation,
                            child: Container(
                              height: circleSize,
                              width: circleSize,
                              decoration: const BoxDecoration(
                                color: addCatScheduleButtonColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        SizeTransition(
                          sizeFactor: checkAnimation,
                          axis: Axis.horizontal,
                          axisAlignment: -1,
                          child: Center(
                            child: Icon(Icons.check_rounded, color: Colors.white, size: iconSize),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 10,
                          child: Row(
                            children: const [
                              Text('Actualizando lista', style: TextStyle(fontSize: 10),),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(color: darkColor, strokeWidth: 2,),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            left: 10,
                            bottom: 0,
                            child: Image.asset('assets/images/cat_2_cropped.png', height: 70,))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete((){
      scaleController.reset();
      checkController.reset();
    });
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    double result = widget.evaluationResult.result;

    final tween = MultiTween<ContainerColors>()
      ..add(ContainerColors.first, ColorTween(begin: complementaryColor, end: secondaryColor), const Duration(seconds: 3))
      ..add(ContainerColors.second, ColorTween(begin: secondaryColor, end: complementaryColor), const Duration(seconds: 3));

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              top: MediaQuery.of(context).viewPadding.top + 30, //logo size
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
                              margin: const EdgeInsets.symmetric(horizontal: 15),
                              height: (screenSize.height/3),
                              width: screenSize.width * 0.9,
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
                    top: 25, left: 20,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: primaryColor,
                      child: InkWell(
                        child: const Icon(Icons.arrow_back_ios_rounded, size: 25.0, color: Colors.white,),
                        onTap: (){
                          if(Provider.of<CameraViewModel>(context, listen: false).getPhotos().length == 1){
                            Provider.of<EvaluationViewModel>(context, listen: false).clearEvaluationList();
                            Provider.of<CameraViewModel>(context, listen: false).cleanPhotos();
                            Navigator.pop(context);
                          }
                          else{
                            Navigator.pop(context);
                          }
                        },
                      ),
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
                                    backgroundColor: result < 0.5 ? evaluationOption : addCatScheduleButtonColor,
                                    child: Text((widget.evaluationResult.result * 100).toStringAsFixed(1) + '%', style: const TextStyle(fontSize: 25, color: Colors.white),),
                                    maxRadius: 45,
                                    minRadius: 35,
                                  ),
                                  SizedBox(
                                    width: screenSize.width/2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Resultado',
                                          style: TextStyle(
                                            fontSize: 15.0, fontWeight: FontWeight.bold,
                                          ), textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        result < 0.5 ?
                                        const Text('Esta comida no es lo suficientemente compatible con tu gatito.',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ), textAlign: TextAlign.start,
                                        ) :
                                        const Text('Esta comida es compatible y recomendable para tu gatito.',
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
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                actionsAlignment: MainAxisAlignment.spaceBetween,
                                title: const Text('Para continuar con el guardado por favor ingrese un nombre', style: TextStyle(fontSize: 18.0), textAlign: TextAlign.justify),
                                content: Form(
                                  key: _formKey,
                                  child: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 300,
                                            child: TextFormField(
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  height: 1
                                              ),
                                              decoration: const InputDecoration(
                                                  hintText: 'Nombre de comida',
                                                  filled: true,
                                                  fillColor: Color(0xFFFAFAFA),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                                  ),),
                                              onSaved: (value) {
                                                name = value!;
                                              },
                                              textInputAction: TextInputAction.done,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Ingrese un nombre";
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 5.0),
                                          const Text('Se recomienda ingresar el nombre de la comida', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                        ],
                                      )),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)
                                ),
                                  actions: [
                                    ElevatedButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: cancelButtonColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25.0)
                                          )
                                      ),
                                    ),
                                    ElevatedButton(
                                      child: const Text('Registrar'),
                                      onPressed: () async {
                                        bool validated = _formKey.currentState!.validate();
                                        if(validated){
                                          _formKey.currentState!.save();
                                          await Provider.of<EvaluationViewModel>(context, listen: false).registerEvaluatedFood(widget.evaluationResult).then((efDtoId){
                                            Provider.of<EvaluationViewModel>(context, listen: false).registerEvaluationResult(widget.evaluationResult, efDtoId, name).then((erDtoId){
                                              Provider.of<EvaluationViewModel>(context, listen: false).registerEvaluationPhoto(widget.image, erDtoId).whenComplete((){
                                                Navigator.pop(context);
                                                _registerSuccess(screenSize);
                                              });
                                            });

                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25.0)
                                          )
                                      ),
                                    )
                                  ].map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: e,
                                  )).toList(),
                              );
                            }
                        );
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