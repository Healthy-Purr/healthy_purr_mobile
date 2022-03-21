import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/providers/provider.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
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

  late bool loader;
  bool isHiddenPassword = false;

  void _saveForm(Function open) {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      Provider.of<RegisterProvider>(context, listen: false).updateLoader(true);
      Provider.of<UserService>(context, listen: false)
          .loginUser(_toSend, context)
          .then((value) {
        if (value == true) {
          open();
          _formKey.currentState!.reset();
          Provider.of<RegisterProvider>(context, listen: false)
              .updateLoader(false);
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

    return Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.only(top: 120, bottom: 100),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 3),
                )
              ]
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        style: const TextStyle(
                            fontSize: 14,
                            height: 0.5
                        ),
                        decoration: const InputDecoration(
                          hintText: 'example@example.com',
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        style: const TextStyle(
                            fontSize: 14,
                            height: 0.5
                        ),
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            suffixIcon: InkWell(
                              child: isHiddenPassword == true
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onTap: _togglePassword,
                            )),
                        onSaved: (value) {
                          _toSend = UserLoginDto(_toSend.email, value!);
                        },
                        obscureText: isHiddenPassword,
                        textInputAction: TextInputAction.done,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Ingrese una contraseña";
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      children: [
                        OpenContainer(
                          closedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          routeSettings: const RouteSettings(name: LoggedInView.routeName),
                          openBuilder: (context, _) => const LoggedInView(),
                          closedBuilder: (_, open) => ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          complementaryColor,
                                          secondaryColor,
                                        ],
                                        stops: [0.05, 1],
                                      ),
                                    ),
                                  ),
                                ),
                                Ink(
                                  width: 250,
                                  child: TextButton(
                                    onPressed: () {
                                      _saveForm(open);
                                      //cierra teclado
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      textStyle: const TextStyle(fontSize: 18),
                                    ),
                                    child: Text('Iniciar Sesión',
                                        style: GoogleFonts.raleway()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const ForgotPasswordButton(),
                        const RegisterButton(),
                        const SizedBox(height: 20),
                        GoBackButton(onPressed: widget.goToHomeView)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
