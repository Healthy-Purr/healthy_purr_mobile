import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/providers/provider.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/views/authentication_views/register_success_view.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: 0,
            child: Image.asset('assets/images/top-right_decoration.png',
                height: 400, alignment: Alignment.topLeft, fit: BoxFit.contain),
          ),
          Positioned(
              top: 60.0,
              left: 15.0,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, size: 40.0),
              )),
          const Positioned(
            top: 120, bottom: 40, right: 20, left: 20,
            child: RegisterForm(),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with SingleTickerProviderStateMixin {

  UserRegisterDto _toSend = UserRegisterDto("", "", "", "");

  final _formKey = GlobalKey<FormState>();

  File? image;
  bool loader = false;
  bool isHiddenPassword = false;

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final _temp = File(image.path);
    setState(() => this.image = _temp);
  }

  void _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loader = true;
      });
      await Provider.of<UserService>(context, listen: false)
          .registerUser(_toSend, context).then((value) {
          if(image != null){
            Provider.of<UserService>(context, listen: false).loginUser(UserLoginDto(_toSend.email, _toSend.password)).then((value){
              Provider.of<UserService>(context, listen: false).uploadUserImage(image!, UserSession().id!);
              _formKey.currentState!.reset();
              setState(() {
                loader = false;
              });
              Navigator.pushReplacement(context,
                  PageTransition(
                      duration: const Duration(milliseconds: 200),
                      reverseDuration: const Duration(milliseconds: 200),
                      type: PageTransitionType.rightToLeft,
                      child: const RegisterSuccessView()
                  ));
            });
          }
          else{
            _formKey.currentState!.reset();
            setState(() {
              loader = false;
            });
            Navigator.pushReplacement(context,
                PageTransition(
                    duration: const Duration(milliseconds: 200),
                    reverseDuration: const Duration(milliseconds: 200),
                    type: PageTransitionType.rightToLeft,
                    child: const RegisterSuccessView()
                ));
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
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.8,
      width: size.width * 0.9,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 5),
            )
          ]),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Registro de Usuario',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nombre', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(bottom: 25.0),
                            child: SizedBox(
                              width: size.width * 0.4,
                              child: TextFormField(
                                  style: const TextStyle(fontSize: 14, height: 1),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Ingrese un nombre";
                                    }
                                    if (isAlpha(value) == false) {
                                      return "Ingrese un nombre válido";
                                    }
                                  },
                                  onSaved: (value) {
                                    _toSend = UserRegisterDto(_toSend.email,
                                        _toSend.password, value!, _toSend.lastName);
                                  }),
                            ),
                          ),
                          const Text('Apellido', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                          SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(bottom: 25.0),
                            child: SizedBox(
                              width: size.width * 0.4,
                              child: TextFormField(
                                style: const TextStyle(fontSize: 14, height: 1),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                                    return "Ingrese un apellido";
                                  }
                                  if (isAlpha(value) == false) {
                                    return "Ingrese un apellido válido";
                                  }
                                },
                                onSaved: (value) {
                                  _toSend = UserRegisterDto(_toSend.email,
                                      _toSend.password, _toSend.name, value!);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          pickImage(ImageSource.gallery);
                        },
                        child: Container(
                          height: 160,
                          width: 130,
                          margin: const EdgeInsets.fromLTRB(20.0, 25.0, 0.0, 25.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
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
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: Image.file(
                                          image!,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        decoration: const BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0))),
                                        height: 120,
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
                                    ])
                              ]),
                        ),
                      ),
                    ],
                  ),
                  const Text('Correo electrónico', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                  SizedBox(height: 10),
                  Container(
                    width: 350,
                    margin: const EdgeInsets.only(bottom: 25),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14, height: 1),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
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
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Ingrese un correo";
                        }
                        if (!value.contains("@")) {
                          return "Ingrese un correo valido";
                        }
                      },
                      onSaved: (value) {
                        _toSend = UserRegisterDto(
                            value!, _toSend.password, _toSend.name, _toSend.lastName);
                      },
                    ),
                  ),
                  const Text('Contraseña', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        style: const TextStyle(fontSize: 14, height: 1),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15),
                            filled: true,
                            fillColor: Color(0xFFFAFAFA),
                            hintText: 'Contraseña',
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(25.0))),
                            suffixIcon: InkWell(
                              child: isHiddenPassword == false
                                  ? const Icon(Icons.visibility, color: darkColor,)
                                  : const Icon(Icons.visibility_off, color: darkColor,),
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
                          _toSend = UserRegisterDto(
                              _toSend.email, value!, _toSend.name, _toSend.lastName);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: loader
                  ? Container(
                padding: const EdgeInsets.all(4),
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
                  : ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                child: Stack(
                  alignment: Alignment.center,
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
          ],
        ),
      ),
    );
  }
}
