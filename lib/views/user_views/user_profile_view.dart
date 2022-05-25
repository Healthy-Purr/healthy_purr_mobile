import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/schedule_view_models/schedule_list_view_model.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:provider/provider.dart';

import '../../services/notification_service.dart';
import '../../services/user_service.dart';
import '../authentication_views/authentication_view.dart';

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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListBody(
              children: const <Widget>[
                Text('¿Desea cerrar sesión?', style: TextStyle(color: Colors.black, fontSize: 15)),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
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
              child: const Text('Continuar'),
              onPressed: () async {
                Navigator.of(context).pop();
                Provider.of<ScheduleListViewModel>(context, listen: false).resetScheduleList();
                await Provider.of<UserService>(context, listen: false).cleanUserSession().whenComplete((){
                  NotificationService().showNotification(
                      context,
                      userLogoutSuccessful,
                      "neutral");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (ctx) => const AuthenticationView()
                      ), (Route<dynamic> route) => false);
                });
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

    final ImageProvider userImage = Provider.of<UserViewModel>(context, listen: false).getUserImage();

    final screenSize = MediaQuery.of(context).size;

    return Drawer(
      backgroundColor: primaryColor,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 20, left: 30, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Image.asset('assets/images/splash.png', height: 30,),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(15.0)),
                          image: DecorationImage(
                            image:  userImage,
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    const GoToEditProfileButton()
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '${UserSession().name!} ${UserSession().lastName!}'.toTitleCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                const SizedBox(
                  height: 5,
                ),
                Text(UserSession().userName!, style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const[
                      CatCountContainer(),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          primary: primaryColor,
                          onPrimary: Colors.white
                      ),
                      onPressed: (){
                        showAboutDialog(
                          context: context,
                          applicationVersion: '1.0.0',
                          applicationIcon: Image.asset(
                            'assets/images/logo_color.png',
                            fit: BoxFit.contain,
                            width: 45, height: 45,
                          ),
                          applicationName: 'Healthy Purr',
                          applicationLegalese: 'Todos las licencias se encuentran autorizadas y registradas en la página de licencias.'
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: const [
                              Icon(FontAwesomeIcons.info, color: Colors.white),
                              SizedBox(width: 30.0),
                            ],
                          ),
                          const Text('Acerca de', style: TextStyle(color: Colors.white),)
                        ],
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                          primary: primaryColor,
                          onPrimary: Colors.white
                      ),
                      onPressed: (){
                        _showMyDialog();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(FontAwesomeIcons.signOutAlt, color: Colors.white),
                          Text('Cerrar Sesión', style: TextStyle(color: Colors.white),)
                        ],
                      )
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );

    //   Scaffold(
    //   extendBody: true,
    //   backgroundColor: Colors.white,
    //   body: SizedBox(
    //     height: screenSize.height,
    //     width: screenSize.width,
    //     child: Stack(
    //       children: [
    //         Positioned(
    //             right: 0,
    //             child: Image.asset(topRightDecoration, height: 400,
    //                 alignment: Alignment.topLeft, fit: BoxFit.contain
    //             )
    //         ),
    //         Positioned(
    //           left: 25, top: MediaQuery.of(context).viewPadding.top,
    //           child: Image.asset(healthyPurrLogo, height: 35,
    //               alignment: Alignment.topLeft, fit: BoxFit.contain),
    //         ),
    //         Positioned(
    //           top: MediaQuery.of(context).viewPadding.top + 40, //logo size
    //           bottom: 40, right: 10, left: 10,
    //           child: Container(
    //             margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: const BorderRadius.all(
    //                     Radius.circular(25.0)),
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Colors.black.withOpacity(0.1),
    //                     spreadRadius: 1,
    //                     blurRadius: 1,
    //                     offset: const Offset(0, 3),
    //                   )
    //                 ]
    //             ),
    //             child: Column(
    //               children: [
    //                 Container(
    //                   height: screenSize.width*0.45,
    //                   width: screenSize.width*0.40,
    //                   margin: const EdgeInsets.symmetric(vertical: 20.0),
    //                   padding: const EdgeInsets.all(10.0),
    //                   decoration: BoxDecoration(
    //                     color: primaryColor,
    //                     borderRadius: BorderRadius.circular(25.0),
    //                       boxShadow: [
    //                         BoxShadow(
    //                           color: Colors.grey.withOpacity(0.5),
    //                           spreadRadius: 1,
    //                           blurRadius: 1,
    //                           offset: const Offset(0, 3),
    //                         )
    //                       ]
    //                   ),
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(25.0),
    //                         image: DecorationImage(
    //                             image: userImage,
    //                             fit: BoxFit.cover
    //                         )
    //                     ),
    //                   ),
    //                 ),
    //                 Text('${UserSession().name!} ${UserSession().lastName!}'.toTitleCase(),
    //                   style: const TextStyle(fontSize: 14.0)),
    //                 Text(UserSession().userName!.onlyUsername(), style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100)),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: const [
    //                     CatCountContainer(),
    //                     GoToEditProfileButton()
    //                   ],
    //                 ),
    //                 const Spacer(),
    //                 const GoBackToProfileButton(),
    //                 const LogoutButton()
    //               ],
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
