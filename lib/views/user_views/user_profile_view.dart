import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {


    //final selectedCat = Provider.of<CatListViewModel>(context, listen: false).selectedCat;

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
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(25.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 3),
                      )
                    ]
                ),
                child: Column(
                  children: [
                    Text(UserSession().userName!),
                    //Text(selectedCat.name!)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
