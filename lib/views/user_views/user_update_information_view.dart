import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class UserUpdateInformationView extends StatefulWidget {
  const UserUpdateInformationView({Key? key}) : super(key: key);

  @override
  State<UserUpdateInformationView> createState() => _UserUpdateInformationViewState();
}

class _UserUpdateInformationViewState extends State<UserUpdateInformationView> {

  final _formKey = GlobalKey<FormState>();

  bool loader = false;

  bool isHiddenPassword = false;

  UserUpdateDto _toSend = UserUpdateDto("", "", "", "", DateTime.now().toString());

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        loader = true;
      });
      _formKey.currentState!.save();
      Provider.of<UserService>(context, listen: false).updateUser(_toSend, context).then((value){
        setState(() {
          loader = false;
        });
        NotificationService().showNotification(
            context,
            userUpdateSuccessful,
            "success");
        Navigator.pushReplacement(context,
            MaterialPageRoute(
              builder: (context) => const LoggedInView(),
            )
        );
      });
    }
  }

  void _togglePassword() {
    setState(() => isHiddenPassword = !isHiddenPassword);
  }

  @override
  void dispose() {
    super.dispose();
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
              left: 25, top: MediaQuery.of(context).viewPadding.top + 47,
              child: const Text(
                'Actualización de datos del Usuario',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 65,
              bottom: 40, right: 10, left: 10,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
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
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //NAME
                          Container(
                            width: screenSize.width * 0.65,
                            margin: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                                initialValue: UserSession().name!,
                                style: const TextStyle(fontSize: 14, height: 1),
                                decoration: const InputDecoration(
                                  labelText: 'Nombre',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                                ),
                                textInputAction: TextInputAction.next,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Ingrese un nombre";
                                  }
                                  if (isAlpha(value) == false) {
                                    return "Ingrese un nombre válido";
                                  }
                                },
                                onSaved: (value) {
                                  _toSend = UserUpdateDto(
                                      value!,
                                      _toSend.lastName,
                                      _toSend.userName,
                                      _toSend.password,
                                      _toSend.birthDate);
                                  UserSession().name = value;
                                }),
                          ),
                          //LASTNAME
                          Container(
                            width: screenSize.width * 0.65,
                            margin: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              initialValue: UserSession().lastName!,
                              style: const TextStyle(fontSize: 14, height: 1),
                              decoration: const InputDecoration(
                                labelText: 'Apellido',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                              ),
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Ingrese su apellido";
                                }
                                if (isAlpha(value) == false) {
                                  return "Ingrese un apellido válido";
                                }
                              },
                              onSaved: (value) {
                                _toSend = UserUpdateDto(
                                    _toSend.name,
                                    value!,
                                    _toSend.userName,
                                    _toSend.password,
                                    _toSend.birthDate,
                                );
                                UserSession().lastName = value;
                              },
                            ),
                          ),
                          //USERNAME
                          Container(
                            width: screenSize.width * 0.65,
                            margin: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              initialValue: UserSession().userName!,
                              style: const TextStyle(fontSize: 14, height: 1),
                              decoration: const InputDecoration(
                                labelText: 'Correo electrónico',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                              ),
                              textInputAction: TextInputAction.next,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty ) {
                                  return "Ingrese su correo";
                                }
                                if (!value.contains('@')) {
                                  return "Ingrese un correo electrónico válido";
                                }
                              },
                              onSaved: (value) {
                                _toSend = UserUpdateDto(
                                    _toSend.name,
                                    _toSend.lastName,
                                    value!,
                                    _toSend.password,
                                    _toSend.birthDate,
                                );
                                UserSession().userName = value;
                              },
                            ),
                          ),
                          //PASSWORD
                          Container(
                            width: screenSize.width * 0.65,
                            margin: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              initialValue: UserSession().password!,
                              style: const TextStyle(fontSize: 14, height: 1),
                              decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                                  suffixIcon: InkWell(
                                    child: isHiddenPassword == false
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                    onTap: _togglePassword,
                                  )),
                              obscureText: !isHiddenPassword,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Ingrese una contraseña";
                                }
                              },
                              onSaved: (value) {
                                _toSend = UserUpdateDto(
                                  _toSend.name,
                                  _toSend.lastName,
                                  _toSend.userName,
                                  value!,
                                  _toSend.birthDate
                                );
                                UserSession().password = value;
                              },
                            ),
                          ),
                          //BUTTONS
                          loader == false
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(left: 30.0,
                                        top: 10.0, bottom: 20.0),
                                    width: screenSize.width * 0.29,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                        child: SizedBox(
                                          width: 250,
                                          height: 50,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(width: 3, color: const Color(0xffE7558F)),
                                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                                            padding:
                                            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                            child: const Center(
                                              child: Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Color(0xffE7558F),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 30.0,
                                      top: 10.0, bottom: 20.0),
                                  width: screenSize.width * 0.475,
                                  child: ClipRRect(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(20.0)),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xffE7558F),
                                                  Color(0xffFFD98E),
                                                ],
                                                stops: [0.05, 1],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Ink(
                                          child: TextButton(
                                            onPressed: (){
                                              _saveForm();
                                            },
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              textStyle: const TextStyle(fontSize: 18),
                                            ),
                                            child: Center(
                                              child: Text('Continuar',
                                                  style: GoogleFonts.comfortaa()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                          )
                          : JumpingDotsProgressIndicator(fontSize: 45.0),

                          const SizedBox(height: 30.0)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
