
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/view_models/camera_view_models/camera_view_model.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/constants.dart';
import '../evaluation/comparison_result_view.dart';
import '../evaluation/evaluation_result_view.dart';
import 'checking_message_view.dart';

class PhotosListView extends StatefulWidget {

  const PhotosListView({Key? key}) : super(key: key);

  @override
  _PhotosListViewState createState() => _PhotosListViewState();
}

enum ContainerColors {first, second}

class _PhotosListViewState extends State<PhotosListView> {

  @override
  void initState() {

    super.initState();
  }

  _showDialog(){
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: const Text('Lo sentimos', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListBody(
              children: const <Widget>[
                Text('No se ha podido identificar texto en la foto por lo que no se pudo completar la evaluación', style: TextStyle(color: Colors.black, fontSize: 15)),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Continuar'),
              onPressed: () async {
                Provider.of<EvaluationViewModel>(context, listen: false).clearEvaluationList();
                Provider.of<CameraViewModel>(context, listen: false).cleanPhotos();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

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
              right: 20, top: MediaQuery.of(context).viewPadding.top + 10,
              child: Image.asset('assets/images/splash.png', height: 40,),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 40, //logo size
              bottom: 0, right: 0, left: 0,
              child: const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: CheckingMessageView(text: 'Espere un momento por favor, se están evaluando las comidas.',),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 200, //logo size
              bottom: 0, right: 0, left: 0,
              child: Column(
                children: [
                  Center(
                    child: Wrap(
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: List.generate(Provider.of<CameraViewModel>(context, listen: false).getPhotos().length, (index){
                        Future resultByIndex = Provider.of<EvaluationViewModel>(context, listen: false).getTextCatFood(Provider.of<CameraViewModel>(context, listen: false).getPhotos()[index]).then((value) {
                          if(value != ""){
                            Provider.of<EvaluationViewModel>(context, listen: false).getCatFoodAnalysis(value).then((catFoodAnalysis){
                              if(catFoodAnalysis.analysis != null && catFoodAnalysis.analysis!.protein! > 0.0 && catFoodAnalysis.analysis!.moisture! > 0.0 && catFoodAnalysis.analysis!.fiber! > 0.0 &&
                                  catFoodAnalysis.analysis!.calcium! > 0.0){
                                Provider.of<EvaluationViewModel>(context, listen: false).evaluateCatFood(catFoodAnalysis, index).whenComplete((){
                                  if(Provider.of<EvaluationViewModel>(context, listen: false).getFinalEvaluationList().isNotEmpty){
                                    if(Provider.of<EvaluationViewModel>(context, listen: false).getFinalEvaluationList().length == Provider.of<CameraViewModel>(context, listen: false).getPhotos().length){
                                      if(Provider.of<EvaluationViewModel>(context, listen: false).getFinalEvaluationList().length > 1){
                                        Navigator.pushReplacement(context,
                                            PageTransition(
                                                duration: const Duration(milliseconds: 200),
                                                reverseDuration: const Duration(milliseconds: 200),
                                                type: PageTransitionType.rightToLeft,
                                                child: const ComparisonListView()
                                            )
                                        );
                                      }
                                      else{
                                        Navigator.pushReplacement(context,
                                            PageTransition(
                                                duration: const Duration(milliseconds: 200),
                                                reverseDuration: const Duration(milliseconds: 200),
                                                type: PageTransitionType.rightToLeft,
                                                child: EvaluationResultView(
                                                    index: 0,
                                                    image: Provider.of<CameraViewModel>(context, listen: false).getPhotos()[0],
                                                    evaluationResult: Provider.of<EvaluationViewModel>(context, listen: false).getEvaluations()[0]
                                                )
                                            )
                                        );
                                      }
                                    }
                                  }
                                  else{
                                    _showDialog();
                                  }
                                });
                              }
                              else{
                                _showDialog();
                              }
                            });
                          }
                          else{
                            _showDialog();
                          }
                        });
                        return SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                  height: 170,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                    image: DecorationImage(image: FileImage(Provider.of<CameraViewModel>(context, listen: false).getPhotos()[index]), fit: BoxFit.cover),
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Comida ${index + 1}', style: const TextStyle(fontSize: 12),),
                                    Provider.of<EvaluationViewModel>(context).getFinalEvaluationList()[index] != 0.0 ?
                                    const Icon(CupertinoIcons.check_mark_circled_solid, color: addCatScheduleButtonColor, size: 15,) :
                                    const SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: evaluationOption,))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                        }
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
}
