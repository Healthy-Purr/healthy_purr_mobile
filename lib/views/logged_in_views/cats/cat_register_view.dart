import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          if(catDiseases.isNotEmpty){
            Provider.of<DiseaseListViewModel>(context, listen: false).registerDiseaseList(cat, catDiseases);
          }
          if(catAllergies.isNotEmpty){
            Provider.of<AllergyListViewModel>(context, listen: false).registerAllergyList(cat, catAllergies);
          }
          Provider.of<CatService>(context, listen: false).uploadCatImage(image!, cat).then((value){
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
                right: -50,
                child: Image.asset(topRightDecoration, height: 400,
                    alignment: Alignment.topLeft, fit: BoxFit.contain
                )
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 10,
              bottom: 0, right: 0, left: 0,
              child: Scrollbar(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(25.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 10),
                        )
                      ]
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 30.0),
                          child: Text('Registro de Gato', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        ),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              //NAME
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Nombre', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                    const SizedBox(height: 5,),
                                    TextFormField(
                                        style: const TextStyle(fontSize: 14, height: 1),
                                        decoration: const InputDecoration(
                                          hintText: 'Nombre',
                                          filled: true,
                                          fillColor: Color(0xFFFAFAFA),
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
                                          _toSend = CatRegisterDto(
                                              value!,
                                              _toSend.age,
                                              _toSend.weight,
                                              _toSend.gender,
                                              _toSend.isAllergic,
                                              _toSend.hasDisease);
                                        }),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //AGE
                                      const Text('Edad', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                      SizedBox(
                                        width: 180,
                                        child: TextFormField(
                                          style: const TextStyle(fontSize: 14, height: 1),
                                          decoration: const InputDecoration(
                                            hintText: 'Edad',
                                            filled: true,
                                            fillColor: Color(0xFFFAFAFA),
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
                                      const Text('Peso', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                      SizedBox(
                                        width: 180,
                                        child: TextFormField(
                                          style: const TextStyle(fontSize: 14, height: 1),
                                          decoration: const InputDecoration(
                                            hintText: 'Peso',
                                            filled: true,
                                            fillColor: Color(0xFFFAFAFA),
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
                                      const Text('Género', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                      Container(
                                        height: 50,
                                        width: 180,
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFFAFAFA),
                                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                            ),
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
                                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                                      child: e,
                                    )).toList(),
                                  ),
                                  //IMAGE
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
                              const SizedBox(
                                height: 15,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 18.0),
                                child: Text('Seleccione la condición de su gato', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
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
                                            itemBuilder: (Checkbox cb, Text txt, int i) {
                                              return  Row(
                                                children: [
                                                  const SizedBox(width: 12.0),
                                                  cb,
                                                  const SizedBox(width: 12.0),
                                                  txt,
                                                ],
                                              );
                                            },
                                            activeColor: primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
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
                                            itemBuilder: (Checkbox cb, Text txt, int i) {
                                              return  Row(
                                                children: [
                                                  const SizedBox(width: 12.0),
                                                  cb,
                                                  const SizedBox(width: 12.0),
                                                  txt,
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //ACTION BUTTONS
                        loader == false?
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 20.0,
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
                                margin: const EdgeInsets.only(right: 20.0,
                                    top: 10.0, bottom: 20.0),
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
                                                secondaryColor,
                                              ],
                                              begin: Alignment.bottomLeft,
                                              end: Alignment.topRight,
                                              stops: [0.01, 1],
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
                        ) :
                        JumpingDotsProgressIndicator(fontSize: 45.0)
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
