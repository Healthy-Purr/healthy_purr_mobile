import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/views/logged_in_views/logged_in_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../services/notification_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/constants/messages.dart';
import '../../view_models/allergy_view_models/allergy_list_view_model.dart';
import '../../view_models/cat_view_models/cat_list_view_model.dart';
import '../../view_models/disease_view_models/disease_list_view_model.dart';
import '../../view_models/evaluation_view_models/evaluation_record_view_model.dart';
import '../../view_models/schedule_view_models/schedule_list_view_model.dart';
import '../../view_models/user_view_models/user_view_model.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  LoginValidateState createState() => LoginValidateState();
}

class LoginValidateState extends State<LoadingView> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CatListViewModel>(context, listen: false).populateCatList(context).whenComplete(() =>
        Provider.of<CatListViewModel>(context, listen: false).populateCatsImages(context).whenComplete(() {
          Provider.of<ScheduleListViewModel>(context, listen: false).populateScheduleList(context).whenComplete((){
            Provider.of<DiseaseListViewModel>(context, listen: false).populateDiseaseList().whenComplete(() =>
                Provider.of<AllergyListViewModel>(context, listen: false).populateAllergyList().whenComplete((){
                  Provider.of<EvaluationRecordViewModel>(context, listen: false).populateEvaluationResultList().whenComplete((){
                    Provider.of<UserViewModel>(context, listen: false).setUserImage().whenComplete((){
                      Navigator.pushReplacement(context,
                          PageTransition(
                              duration: const Duration(milliseconds: 200),
                              reverseDuration: const Duration(milliseconds: 200),
                              type: PageTransitionType.rightToLeft,
                              child: const LoggedInView()
                          ));
                      NotificationService().showNotification(
                          context,
                          loginSuccessful,
                          "success");
                    });
                  });
                })
            );
          });
        }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset("assets/images/splash.png", width: size.width/10,),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: size.width/6,
                height: size.width/6,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}