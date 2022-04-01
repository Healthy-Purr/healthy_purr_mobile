import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/providers/provider.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
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
          const Padding(
            padding: EdgeInsets.only(top: 120.0),
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

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        loader = true;
      });
      Provider.of<UserService>(context, listen: false)
          .registerUser(_toSend, context)
          .then((value) {
        _formKey.currentState!.reset();
        setState(() {
          loader = false;
        });
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

    return Container(
      height: 500,
      width: 380,
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
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
          ]),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 25.0),
                      child: SizedBox(
                        width: 180,
                        child: TextFormField(
                            style: const TextStyle(fontSize: 14, height: 0.5),
                            decoration: const InputDecoration(
                              hintText: 'Jhon',
                              labelText: 'Nombre',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 25.0),
                      child: SizedBox(
                        width: 180,
                        child: TextFormField(
                          style: const TextStyle(fontSize: 14, height: 0.5),
                          decoration: const InputDecoration(
                            hintText: 'Doe',
                            labelText: 'Apellido',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
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
                Container(
                  height: 160,
                  width: 130,
                  margin: const EdgeInsets.fromLTRB(20.0, 25.0, 0.0, 25.0),
                  decoration: BoxDecoration(
                      color: const Color(0xffE7558F),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 3),
                        )
                      ]),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.file(
                                  image!,
                                  width: 120,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                height: 130,
                                width: 120,
                                child: const Center(
                                    child: Icon(Icons.account_circle,
                                        size: 50.0, color: Colors.black38))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Añadir Foto',
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.white)),
                              const SizedBox(width: 5.0),
                              InkWell(
                                child: const Icon(Icons.add_a_photo_rounded,
                                    size: 14.0, color: Colors.white),
                                onTap: () async {
                                  pickImage(ImageSource.gallery);
                                },
                              ),
                            ])
                      ]),
                ),
              ],
            ),
            SizedBox(
              width: 350,
              child: TextFormField(
                style: const TextStyle(fontSize: 14, height: 0.5),
                decoration: const InputDecoration(
                  hintText: 'example@example.com',
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
            Container(
              margin: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 40.0),
              child: SizedBox(
                width: 350,
                child: TextFormField(
                  style: const TextStyle(fontSize: 14, height: 0.5),
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
                    _toSend = UserRegisterDto(
                        _toSend.email, value!, _toSend.name, _toSend.lastName);
                  },
                ),
              ),
            ),
            loader
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
                                  primaryColor,
                                ],
                                stops: [0.05, 1],
                              ),
                            ),
                          ),
                        ),
                        Ink(
                          child: TextButton(
                            onPressed: () => _saveForm(),
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
            const SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}
