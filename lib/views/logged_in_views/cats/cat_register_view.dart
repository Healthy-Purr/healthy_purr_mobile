import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons_ns/grouped_buttons_ns.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';
import 'dart:io';

class CatRegisterView extends StatefulWidget {
  const CatRegisterView({Key? key}) : super(key: key);

  @override
  State<CatRegisterView> createState() => _CatRegisterViewState();
}

class _CatRegisterViewState extends State<CatRegisterView> {

  final _formKey = GlobalKey<FormState>();

  List<String> catDiseases = [];
  List<String> catAllergies = [];

  File? image;

  //JUMPING DOTS ANIMATION WHEN SENDING HTTP REQUEST
  bool loader = false;
  bool noImage = true;

  //GENDER
  String gender = "Macho";

  CatRegisterDto _toSend = CatRegisterDto("", 0, 0.0, true, false, false);

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (isValid && image != null) {
      setState(() {
        loader = true;
        noImage = false;
      });
      _formKey.currentState!.save();
      Provider.of<CatService>(context, listen: false)
          .createCat(_toSend, UserSession().id!)
          .then((value) {
        _formKey.currentState!.reset();
        Provider.of<CatListViewModel>(context, listen: false).populateCatList(context).then((value) {
          final cat = Provider.of<CatListViewModel>(context, listen: false).getCats().last;
          Provider.of<CatService>(context, listen: false).uploadCatImage(image!, cat);
          Provider.of<CatListViewModel>(context, listen: false).populateCatsImages(context).then((value) {
            setState(() {
              image = null;
              loader = false;
            });
            NotificationService().showNotification(
                context,
                catRegisterSuccessful,
                "success");
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (context) => const LoggedInView(),
                )
            );
          });
        });
      });
    }
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

    final diseaseList = Provider.of<DiseaseListViewModel>(context, listen: false).getDiseases();

    final allergiesList = Provider.of<AllergyListViewModel>(context, listen: false).getAllergies();

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
                'Registro de Gato',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 65,
              bottom: 0, right: 0, left: 0,
              child: Scrollbar(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                //NAME
                                SizedBox(
                                  width: 180,
                                  child: TextFormField(
                                      style: const TextStyle(fontSize: 14, height: 0.5),
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
                                        _toSend = CatRegisterDto(
                                            value!,
                                            _toSend.age,
                                            _toSend.weight,
                                            _toSend.gender,
                                            _toSend.isAllergic,
                                            _toSend.hasDisease);
                                      }),
                                ),
                                //AGE
                                SizedBox(
                                  width: 180,
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14, height: 0.5),
                                    decoration: const InputDecoration(
                                      labelText: 'Edad',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20.0))),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Ingrese edad";
                                      }
                                      if (isNumeric(value) == false) {
                                        return "Ingrese una edad válida";
                                      }
                                    },
                                    onSaved: (value) {
                                      _toSend = CatRegisterDto(
                                          _toSend.name,
                                          int.parse(value!),
                                          _toSend.weight,
                                          _toSend.gender,
                                          _toSend.isAllergic,
                                          _toSend.hasDisease);
                                    },
                                  ),
                                ),
                                //WEIGHT
                                SizedBox(
                                  width: 180,
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 14, height: 0.5),
                                    decoration: const InputDecoration(
                                      labelText: 'Peso',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20.0))),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Ingrese peso";
                                      }
                                      if (isFloat(value) == false) {
                                        return "Ingrese un peso válido";
                                      }
                                    },
                                    onSaved: (value) {
                                      _toSend = CatRegisterDto(
                                          _toSend.name,
                                          _toSend.age,
                                          double.parse(value!),
                                          _toSend.gender,
                                          _toSend.isAllergic,
                                          _toSend.hasDisease);
                                    },
                                  ),
                                ),
                                //GENDER
                                Container(
                                  height: 50,
                                  width: 180,
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                      border: Border.all(color: Colors.grey)),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                      value: gender,
                                      icon: const Icon(Icons.arrow_forward_ios, size: 15.0),
                                      style: GoogleFonts.comfortaa(color: Colors.black54),
                                      onChanged: (String? newValue){
                                        setState((){
                                          gender = newValue!;
                                          if (gender == 'Macho') {
                                            _toSend = CatRegisterDto(
                                                _toSend.name,
                                                _toSend.age,
                                                _toSend.weight,
                                                true,
                                                _toSend.isAllergic,
                                                _toSend.hasDisease);
                                          } else {
                                            _toSend = CatRegisterDto(
                                                _toSend.name,
                                                _toSend.age,
                                                _toSend.weight,
                                                false,
                                                _toSend.isAllergic,
                                                _toSend.hasDisease);
                                          }
                                        });
                                      },
                                      items: <String>['Macho', 'Hembra'].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ].map((e) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 10.0),
                                child: e,
                              )).toList(),
                            ),
                            //IMAGE
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  height: 160,
                                  width: 130,
                                  margin: const EdgeInsets.fromLTRB(20.0, 25.0, 0.0, 25.0),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffFFD28E),
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
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: ListTileTheme(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                dense: true,
                                child: ExpansionTile(
                                  maintainState: true,
                                  iconColor: primaryColor,
                                  textColor: Colors.black54,
                                  title: const Text('Alergias', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                  children: [
                                    CheckboxGroup(
                                      labels: allergiesList.map((e) => e.name!).toList(),
                                      onSelected: (List<String> selected) {
                                        setState(() {
                                          catAllergies = selected;
                                        });
                                        if(catAllergies.isNotEmpty) {
                                          _toSend = CatRegisterDto(
                                              _toSend.name,
                                              _toSend.age,
                                              _toSend.weight,
                                              _toSend.gender,
                                              _toSend.hasDisease,
                                              true
                                          );
                                        } else {
                                          _toSend = CatRegisterDto(
                                              _toSend.name,
                                              _toSend.age,
                                              _toSend.weight,
                                              _toSend.gender,
                                              _toSend.hasDisease,
                                              false
                                          );
                                        }
                                      },
                                      activeColor: primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: ListTileTheme(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                dense: true,
                                child: ExpansionTile(
                                  maintainState: true,
                                  iconColor: primaryColor,
                                  textColor: Colors.black54,
                                  title: const Text('Enfermedades', style: TextStyle(fontSize: 14, color: Colors.black54)),
                                  children: [
                                    CheckboxGroup(
                                      labels: diseaseList.map((e) => e.name!).toList(),
                                      onSelected: (List<String> selected) {
                                        setState(() {
                                          catDiseases = selected;
                                        });
                                        if(catDiseases.isNotEmpty) {
                                          _toSend = CatRegisterDto(
                                              _toSend.name,
                                              _toSend.age,
                                              _toSend.weight,
                                              _toSend.gender,
                                              true,
                                              _toSend.isAllergic
                                          );
                                        } else {
                                          _toSend = CatRegisterDto(
                                              _toSend.name,
                                              _toSend.age,
                                              _toSend.weight,
                                              _toSend.gender,
                                              false,
                                              _toSend.isAllergic,
                                          );
                                        }
                                      },
                                      activeColor: primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //ACTION BUTTONS
                            loader == false?
                            Row(
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
                            ) :
                            JumpingDotsProgressIndicator(fontSize: 45.0)
                          ],
                        ),
                      ],
                    ),
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
