import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_buttons_ns/grouped_buttons_ns.dart';
import 'package:healthy_purr_mobile_app/models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class CatUpdateInformationView extends StatefulWidget {
  final CatViewModel cat;
  const CatUpdateInformationView({required this.cat, Key? key}) : super(key: key);

  @override
  State<CatUpdateInformationView> createState() => _CatUpdateInformationViewState();
}

class _CatUpdateInformationViewState extends State<CatUpdateInformationView> {

  final _formKey = GlobalKey<FormState>();


  List<DiseaseViewModel> diseaseList = [];

  List<AllergyViewModel> allergiesList = [];

  @override
  void initState() {

     diseaseList = Provider.of<DiseaseListViewModel>(context, listen: false).getDiseases();
     allergiesList = Provider.of<AllergyListViewModel>(context, listen: false).getAllergies();

    super.initState();
  }

  List<String> catDiseases = [];
  List<String> catAllergies = [];

  //JUMPING DOTS ANIMATION WHEN SENDING HTTP REQUEST
  bool loader = false;

  @override
  void dispose() {
    super.dispose();
  }

  String gender = 'Macho';

  @override
  Widget build(BuildContext context) {

    CatRegisterDto _toSend = CatRegisterDto(
      widget.cat.name!,
      widget.cat.age!,
      widget.cat.weight!,
      widget.cat.gender!,
      widget.cat.hasDisease!,
      widget.cat.isAllergic!
    );

    void _saveForm() {
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        setState(() {
          loader = true;
        });
        _formKey.currentState!.save();
        if(catDiseases.isNotEmpty){
          Provider.of<DiseaseListViewModel>(context, listen: false).registerDiseaseList(widget.cat, catDiseases);
        }
        if(catAllergies.isNotEmpty){
          Provider.of<AllergyListViewModel>(context, listen: false).registerAllergyList(widget.cat, catAllergies);
        }
        Provider.of<CatService>(context, listen: false)
          .updateCat(_toSend, widget.cat.catId!).then((value){
            Provider.of<CatListViewModel>(context, listen: false).populateCatList(context).then((value){
              setState(() {
                loader = false;
              });
              NotificationService().showNotification(
                  context,
                  catUpdateSuccessful,
                  "success");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(
                    builder: (context) => const LoggedInView(),
                  )
              );
            });
        });
      }
    }

    final screenSize = MediaQuery.of(context).size;


    widget.cat.gender == true ? gender = 'Macho' : gender = 'Hembra';

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
                child: Image.asset(topRightDecoration, height: 350,
                    alignment: Alignment.topLeft, fit: BoxFit.contain
                )
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 20,
              bottom: 40, right: 10, left: 10,
              child: Scrollbar(
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
                            padding: EdgeInsets.zero,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text('Nombre', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: screenSize.width * 0.6,
                                    child: TextFormField(
                                        initialValue: widget.cat.name!,
                                        style: const TextStyle(fontSize: 14, height: 0.5),
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
                                          _toSend = CatRegisterDto(
                                              value!,
                                              _toSend.age,
                                              _toSend.weight,
                                              _toSend.gender,
                                              _toSend.isAllergic,
                                              _toSend.hasDisease);
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text('Edad', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                  Container(
                                    width: screenSize.width * 0.6,
                                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                                    child: TextFormField(
                                      initialValue: widget.cat.age!.toString(),
                                      style: const TextStyle(fontSize: 14, height: 0.5),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFFAFAFA),
                                        hintText: 'Edad',
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
                                  const Text('Peso', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                  Container(
                                    width: screenSize.width * 0.6,
                                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                                    child: TextFormField(
                                      initialValue: widget.cat.weight!.toString(),
                                      style: const TextStyle(fontSize: 14, height: 0.5),
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFFAFAFA),
                                        hintText: 'Peso',
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
                                  const Text('Género', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                  Container(
                                    height: 50,
                                    width: screenSize.width * 0.6,
                                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                        value: gender,
                                        icon: const Icon(Icons.arrow_forward_ios, size: 15.0),
                                        style: GoogleFonts.raleway(color: Colors.black54),
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
                                  //add checked
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('Seleccione la condición de su gato', style: TextStyle(fontSize: 12, color: Color(0xFF9A9A9A))),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                                                activeColor: primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 10.0,),
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
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //ACTION BUTTONS
                        loader == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
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
                                              border: Border.all(width: 3, color: darkColor),
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
                                margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
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
                        : JumpingDotsProgressIndicator(fontSize: 45.0)
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
