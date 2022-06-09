import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/providers/provider.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/views/authentication_views/loading_view.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  final VoidCallback goToHomeView;
  const LoginView({required this.goToHomeView, Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  UserLoginDto _toSend = UserLoginDto("", "");

  final _formKey = GlobalKey<FormState>();

  bool loader = false;
  bool isHiddenPassword = false;

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      Provider.of<UserService>(context, listen: false).setLogin(true);
      _formKey.currentState!.save();
      Provider.of<UserService>(context, listen: false)
          .loginUser(_toSend)
          .then((value) {
        if (value == true) {
          Provider.of<UserService>(context, listen: false).setLogin(false);
          Navigator.pushReplacement(context,
              PageTransition(
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  type: PageTransitionType.rightToLeft,
                  child: const LoadingView()
              ));
          _formKey.currentState!.reset();
        } else {
          Provider.of<UserService>(context, listen: false).setLogin(false);
          NotificationService().showNotification(
              context,
              loginError,
              "error");
        }
      });
    }
  }

  void _togglePassword() {
    isHiddenPassword = !isHiddenPassword;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    loader = Provider.of<RegisterProvider>(context, listen: false).loader;

    var screenSize = MediaQuery.of(context).size;

    return Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30, top: screenSize.height * 0.1, bottom: 10),
          height: screenSize.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ]
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Correo', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A)),),
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: 14,
                                height: 1,
                            ),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xFFFAFAFA),
                              hintText: 'example@example.com',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Ingrese un correo";
                              }
                              // if (!value.contains("@")) {
                              //   return "Ingrese un correo valido";
                              // }
                            },
                            onSaved: (value) {
                              _toSend = UserLoginDto(value!, _toSend.password);
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Text('Contraseña', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: 14,
                                height: 1
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFFAFAFA),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                ),
                                suffixIcon: InkWell(
                                  child: isHiddenPassword == false
                                      ? const Icon(Icons.visibility, color: darkColor,)
                                      : const Icon(Icons.visibility_off, color: darkColor,),
                                  onTap: _togglePassword,
                                )),
                            onSaved: (value) {
                              _toSend = UserLoginDto(_toSend.email, value!);
                            },
                            obscureText: !isHiddenPassword,
                            textInputAction: TextInputAction.done,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Ingrese una contraseña";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 120.0),
                    Provider.of<UserService>(context).getLogin()
                    ? JumpingDotsProgressIndicator(fontSize: 45.0, color: darkColor,) :
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _saveForm();
                            //cierra teclado
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            maximumSize: const Size(250, 50),
                            primary: Colors.transparent,
                            elevation: 0
                          ),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  complementaryColor,
                                  secondaryColor,
                                ],
                                stops: const [0.05, 1],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                              alignment: Alignment.center,
                              child: Text(
                                'Iniciar Sesión',
                                style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        // const ForgotPasswordButton(),
                        // const RegisterButton(),
                        const SizedBox(height: 20),
                        GoBackButton(onPressed: widget.goToHomeView)
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
