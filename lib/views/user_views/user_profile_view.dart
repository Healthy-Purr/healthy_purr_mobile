import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:provider/provider.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
  String onlyUsername() => split('@')[0];
}

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {

  @override
  Widget build(BuildContext context) {

    final ImageProvider userImage = Provider.of<UserViewModel>(context, listen: false).getUserImage();

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
              bottom: 40, right: 10, left: 10,
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
                    Container(
                      height: screenSize.width*0.45,
                      width: screenSize.width*0.40,
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 3),
                            )
                          ]
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            image: DecorationImage(
                                image: userImage,
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    ),
                    Text('${UserSession().name!} ${UserSession().lastName!}'.toTitleCase(),
                      style: const TextStyle(fontSize: 14.0)),
                    Text(UserSession().userName!.onlyUsername(), style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CatCountContainer(),
                        GoToEditProfileButton()
                      ],
                    ),
                    const Spacer(),
                    const GoBackToProfileButton(),
                    const LogoutButton()
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
