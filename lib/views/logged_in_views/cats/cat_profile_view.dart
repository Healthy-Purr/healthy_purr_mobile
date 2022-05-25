import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:io';

class CatProfileView extends StatefulWidget {
  final CatViewModel cat;
  final ImageProvider catImage;
  final int index;
  const CatProfileView({required this.cat, required this.catImage, required this.index,
    Key? key}) : super(key: key);

  @override
  _CatProfileViewState createState() => _CatProfileViewState();
}

enum ContainerColors {first, second}

class _CatProfileViewState extends State<CatProfileView> {

  List<Map<String, String>> catDiseasesList = [];
  List<Map<String, String>> catAllergiesList = [];

  File? image;

  Future pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final _temp = File(image.path);
    setState(() => this.image = _temp);
  }

  late var _future;

  @override
  void initState() {
    _future = Provider.of<AllergyListViewModel>(context, listen: false).populateCatAllergyList(context).whenComplete(() =>
        Provider.of<DiseaseListViewModel>(context, listen: false).populateCatDiseasesList(context).whenComplete(() {
          catAllergiesList = Provider.of<AllergyListViewModel>(context, listen: false).getCatAllergies();
          catDiseasesList = Provider.of<DiseaseListViewModel>(context, listen: false).getCatDiseases();
      })
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    final tween = MultiTween<ContainerColors>()
      ..add(ContainerColors.first, ColorTween(begin: complementaryColor, end: secondaryColor), const Duration(seconds: 3))
      ..add(ContainerColors.second, ColorTween(begin: secondaryColor, end: complementaryColor), const Duration(seconds: 3));

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
            FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return Positioned(
                    top: MediaQuery.of(context).viewPadding.top + 10, //logo size
                    bottom: 0, right: 0, left: 0,
                    child: Stack(
                      children: [
                        ///CAT IMAGE
                        Positioned(
                            top: 20,
                            child: MirrorAnimation<MultiTweenValues<ContainerColors>>(
                                tween: tween,
                                duration: tween.duration,
                                builder: (context, child, animation) {
                                  return Container(
                                    height: (screenSize.height - MediaQuery.of(context).viewPadding.top - 40) / 2,
                                    width: screenSize.width,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: image == null
                                            ? widget.catImage
                                            : FileImage(image!),
                                            fit: BoxFit.fitWidth),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            animation.get(ContainerColors.first),
                                            animation.get(ContainerColors.second),
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20.0),
                                        )
                                    ),
                                  );
                                }
                            )
                        ),
                        ///UPDATE CAT IMAGE CLIP BUTTON
                        Positioned(
                          top: 17, right: screenSize.width * 0.04,
                          child: ClipButton(
                            icon: Icons.add_a_photo_rounded,
                            onTap: () async {
                              await pickImage(ImageSource.gallery).whenComplete((){
                                NotificationService().showNotification(
                                    context,
                                    catImageUpdateSuccessful,
                                    "success");
                                Provider.of<CatService>(context, listen: false).uploadCatImage(image!, widget.cat).whenComplete((){
                                  Provider.of<CatListViewModel>(context, listen: false).setCatImageAtIndex(widget.index, FileImage(image!));
                                });
                              });
                            },
                            color: updateCatImageButtonColor,
                          ),
                        ),
                        ///GO BACK BUTTON
                        Positioned(
                          top: 25, left: 5,
                          child: CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 25,
                            child: InkWell(
                              child: const Icon(Icons.arrow_back_ios_rounded, size: 30.0, color: Colors.white,),
                              onTap: ()=> Navigator.pop(context),
                            ),
                          ),
                        ),
                        ///CAT INFORMATION
                        Positioned(
                            top: (screenSize.height - MediaQuery.of(context).viewPadding.top - 100) / 2, bottom: 0,
                            child: Container(
                              height: (screenSize.height - MediaQuery.of(context).viewPadding.top - 40) / 2,
                              width: screenSize.width,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0),)),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10.0),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('   ${widget.cat.name!}',
                                        style: const TextStyle(
                                          fontSize: 22.0, fontWeight: FontWeight.bold,
                                        ), textAlign: TextAlign.start,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Expanded(
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CatDetailsCard(
                                                    icon: const FaIcon(FontAwesomeIcons.hourglassHalf),
                                                    attribute: 'Edad',
                                                    text: '${widget.cat.age} años',
                                                  ),
                                                  CatDetailsCard(
                                                    icon: const FaIcon(FontAwesomeIcons.weight),
                                                    attribute: 'Peso',
                                                    text: '${widget.cat.weight} kg',
                                                  ),
                                                  CatDetailsCard(
                                                    icon: const FaIcon(FontAwesomeIcons.cat),
                                                    attribute: 'Sexo',
                                                    text: widget.cat.gender == true ?
                                                    'Macho' : 'Hembra',
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      CatDiseasesContainer(diseases: catDiseasesList),
                                                      CatAllergiesContainer(allergies: catAllergiesList)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                        ///UPDATE CAT INFORMATION CLIP BUTTON
                        Positioned(
                          top: ((screenSize.height - MediaQuery.of(context).viewPadding.top - 100) / 2) - 5,
                          right: screenSize.width * 0.04,
                          child: ClipButton(
                            icon: Icons.refresh,
                            onTap: () {
                              Navigator.push(context,
                                  PageTransition(
                                      duration: const Duration(milliseconds: 200),
                                      reverseDuration: const Duration(milliseconds: 200),
                                      type: PageTransitionType.rightToLeft,
                                      child: CatUpdateInformationView(
                                          cat: widget.cat
                                      )
                                  )
                              );
                            },
                            color: complementaryColor,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset("assets/images/logo_color.png", width: screenSize.width * 0.07,),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: screenSize.width * 0.14,
                            height: screenSize.width * 0.14,
                            child: const CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );

  }
}
