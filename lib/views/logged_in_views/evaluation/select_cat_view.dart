import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_view_model.dart';
import 'package:healthy_purr_mobile_app/views/logged_in_views/camera/photos_list_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/constants.dart';
import '../../../utils/widgets/evaluation/select_cat_list.dart';
import '../../../view_models/camera_view_models/camera_view_model.dart';

class SelectCatView extends StatefulWidget {
  const SelectCatView({Key? key}) : super(key: key);

  @override
  State<SelectCatView> createState() => _SelectCatViewState();
}

class _SelectCatViewState extends State<SelectCatView> {

  @override
  void initState() {
    Provider.of<EvaluationViewModel>(context, listen: false).populateEvaluations(Provider.of<CameraViewModel>(context, listen: false).getPhotos().length);
    super.initState();
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
              right: 25, top: MediaQuery.of(context).viewPadding.top + 10,
              child: Image.asset('assets/images/splash.png', height: 35,
                  alignment: Alignment.topLeft, fit: BoxFit.contain),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 40, //logo size
              bottom: 0, right: 0, left: 0,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: screenSize.height,
                width: screenSize.width,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Evaluar',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Row(
                            children: const [
                              Text('Seleccione un gato de la lista'),
                              SizedBox(width: 50.0),
                              Tooltip(
                                margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                waitDuration: Duration(seconds: 0),
                                showDuration: Duration(seconds: 7),
                                verticalOffset: 24,
                                preferBelow: false,
                                message: evaluationSelectionCatMessage,
                                textStyle: TextStyle(fontSize: 11.5, color: Colors.white),
                                child: FaIcon(FontAwesomeIcons.questionCircle),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SelectCatList(),
                              const Text('o realice una evaluación general'),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      PageTransition(
                                          duration: const Duration(milliseconds: 200),
                                          reverseDuration: const Duration(milliseconds: 200),
                                          type: PageTransitionType.rightToLeft,
                                          child: const PhotosListView()
                                      )
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                                    maximumSize: const Size(300, 50),
                                    primary: Colors.transparent,
                                    elevation: 0
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                     gradient: LinearGradient(
                                      colors: [
                                        complementaryColor.withOpacity(0.8),
                                        secondaryColor,
                                      ],
                                      stops: const [0.05, 0.8],
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                                  ),
                                  child: Text(
                                    'Realizar Evaluación General',
                                    style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );



  }
}