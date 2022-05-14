import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/evaluation_view_models/evaluation_view_model.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../views/logged_in_views/camera/photos_list_view.dart';

class SelectCatList extends StatefulWidget {
  const SelectCatList({Key? key}) : super(key: key);

  @override
  _SelectCatListState createState() => _SelectCatListState();
}

class _SelectCatListState extends State<SelectCatList> {

  var catList = [];
  var catImages = [];

  @override
  void initState() {
    // catList = Provider.of<CatListViewModel>(context, listen: false).getCats();
    // catImages = Provider.of<CatListViewModel>(context, listen: false).getCatsImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    catList = Provider.of<CatListViewModel>(context).getCats();
    catImages = Provider.of<CatListViewModel>(context, listen: false).getCatsImages();

    return SizedBox(
      height: screenSize.height * 0.5,
      width: screenSize.width,
      child: catList.isNotEmpty ? ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: catList.length,
          itemBuilder: (context, index) {

            final CatViewModel selectedCat = catList[index];
            final selectedCatImage = catImages[index];

            if(selectedCat.status == true) {
              return GestureDetector(
                onTap: () {
                  Provider.of<EvaluationViewModel>(context, listen: false).setSelectedCat(selectedCat);
                  Provider.of<EvaluationViewModel>(context, listen: false).populateCatAllergyList().whenComplete((){
                    Navigator.pushReplacement(context,
                        PageTransition(
                            duration: const Duration(milliseconds: 200),
                            reverseDuration: const Duration(milliseconds: 200),
                            type: PageTransitionType.rightToLeft,
                            child: const PhotosListView()
                        )
                    );
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 125,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(25.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 6),
                        )
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Row(
                        children: [
                          Container(
                            height: 125,
                            width: 115,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(20.0)),
                              image: DecorationImage(
                                image: Provider.of<CatListViewModel>(context).getCatsImages()[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 25),
                                child: Text(selectedCat.name!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(TextSpan(children: [
                                    const TextSpan(text: 'Edad: ', style: TextStyle(fontSize: 12)),
                                    TextSpan(
                                        text: selectedCat.age.toString() + ' años',
                                        style:
                                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  ])),
                                  Text.rich(TextSpan(children: [
                                    const TextSpan(text: 'Peso: ', style: TextStyle(fontSize: 12)),
                                    TextSpan(
                                        text: selectedCat.weight.toString(),
                                        style:
                                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                    const TextSpan(
                                        text: ' kg',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold))
                                  ])),

                                  Text.rich(TextSpan(children: [
                                    const TextSpan(text: 'Sexo: ', style: TextStyle(fontSize: 12)),
                                    TextSpan(
                                        text: selectedCat.gender.toString() == 'true' ? 'Macho' : 'Hembra',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 12))
                                  ]))
                                ]
                                    .map((children) => Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(25, 6, 0, 0),
                                    child: children))
                                    .toList(),
                              ),
                            ],
                          )
                        ]
                    ),
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }) : Stack(
        alignment: AlignmentDirectional.center,
        children: [
          FaIcon(FontAwesomeIcons.cat, color: primaryColor.withOpacity(0.2), size: 60,),
          SizedBox(
              width: screenSize.width * 0.5,
              child: Text('Cuando tenga gatos podra seleccionarlos aquí', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,)),
        ],
      ),
    );
  }
}