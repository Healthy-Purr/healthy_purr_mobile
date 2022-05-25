import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:image_picker/image_picker.dart';
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

  File? image;

  bool noImage = true;

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

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final _temp = File(image.path);
    setState(() {
      this.image = _temp;
      noImage = false;
    });
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
              top: MediaQuery.of(context).viewPadding.top + 20,
              bottom: 40, right: 10, left: 10,
              child: Container(
                padding: EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(25.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      )
                    ]
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Actualización de datos',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //NAME
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text('Nombre', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: screenSize.width * 0.35,
                                          child: TextFormField(
                                              initialValue: UserSession().name!,
                                              style: const TextStyle(fontSize: 14, height: 1),
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor: Color(0xFFFAFAFA),
                                                hintText: 'Nombre',
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text('Apellido', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                        Container(
                                          width: screenSize.width * 0.35,
                                          margin: const EdgeInsets.symmetric(vertical: 15.0),
                                          child: TextFormField(
                                            initialValue: UserSession().lastName!,
                                            style: const TextStyle(fontSize: 14, height: 1),
                                            decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xFFFAFAFA),
                                              hintText: 'Apellido',
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none,
                                                  ),
                                                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        pickImage(ImageSource.gallery);
                                      },
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Container(
                                            height: 180,
                                            width: 130,
                                            margin: const EdgeInsets.fromLTRB(20.0, 25.0, 0.0, 25.0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                const BorderRadius.all(Radius.circular(15.0)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.07),
                                                    spreadRadius: 1,
                                                    blurRadius: 2,
                                                    offset: const Offset(0, 5),
                                                  )
                                                ]),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  image != null
                                                      ? ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    child: Image.file(
                                                      image!,
                                                      width: 120,
                                                      height: 130,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                      : Container(
                                                      decoration: const BoxDecoration(
                                                          color: secondaryColor,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10.0))),
                                                      height: 130,
                                                      width: 120,
                                                      child: const Center(
                                                          child: Icon(Icons.account_circle,
                                                              size: 50.0, color: Colors.white))),
                                                  Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: const [
                                                        CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor: complementaryColor,
                                                          child: Icon(Icons.add_a_photo_rounded,
                                                              size: 14.0, color: Colors.white),
                                                        ),
                                                      ]),
                                                ]),
                                          ),
                                          noImage == true
                                              ? const Positioned(
                                            bottom: 0, left: 30,
                                            child: Text('Ingresa una foto', style: TextStyle(
                                                color: Colors.red, fontSize: 11)),
                                          )
                                              : const SizedBox()
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                //USERNAME
                                const Text('Correo electrónico', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                Container(
                                  width: screenSize.width * 0.75,
                                  margin: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: TextFormField(
                                    initialValue: UserSession().userName!,
                                    style: const TextStyle(fontSize: 14, height: 1),
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFFAFAFA),
                                      hintText: 'Correo electrónico',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
                                const Text('Contraseña', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                Container(
                                  width: screenSize.width * 0.75,
                                  margin: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: TextFormField(
                                    initialValue: UserSession().password!,
                                    style: const TextStyle(fontSize: 14, height: 1),
                                    decoration: InputDecoration(
                                        hintText: 'Contraseña',
                                        filled: true,
                                        fillColor: Color(0xFFFAFAFA),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(25.0))),
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
                                const SizedBox(height: 30.0)
                              ],
                            )
                          ],
                        ),
                      ),
                      //BUTTONS
                      loader == false
                          ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
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
                                            border: Border.all(width: 2.5, color: darkColor),
                                            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                                        padding:
                                        const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                        child: const Center(
                                          child: Text(
                                            'Cancelar',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: darkColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            Container(
                              width: screenSize.width * 0.4,
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
                                              complementaryColor,
                                              secondaryColor
                                            ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
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
                                          textStyle: const TextStyle(fontSize: 16),
                                        ),
                                        child: Center(
                                          child: Text('Continuar',
                                              style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold)),
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
