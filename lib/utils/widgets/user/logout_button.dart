import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: InkWell(
          splashColor: Colors.red[200],
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(logoutAlertDialogTitle, style: TextStyle(fontSize: 18.0), textAlign: TextAlign.justify),
                  content: const Text(logoutAlertDialogContent, style: TextStyle(fontSize: 14.0), textAlign: TextAlign.justify),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  actions: [
                    ElevatedButton(
                      child: const Text(logoutAlertDialogConfirmAction),
                      onPressed: () async {
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
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)
                          )
                      ),
                    ),
                    ElevatedButton(
                      child: const Text(logoutAlertDialogDismissAction),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
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
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.red),
                borderRadius: const BorderRadius.all(Radius.circular(20.0))
            ),
            child: const Center(
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
