import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class VerticalCatList extends StatefulWidget {
  const VerticalCatList({Key? key}) : super(key: key);

  @override
  _VerticalCatListState createState() => _VerticalCatListState();
}

class _VerticalCatListState extends State<VerticalCatList> {

  var catList = [];
  var catImages = [];

  @override
  void initState() {
    catList = Provider.of<CatListViewModel>(context, listen: false).getCats();
    catImages = Provider.of<CatListViewModel>(context, listen: false).getCatsImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: catList.length,
          itemBuilder: (context, index) {

            final selectedCat = catList[index];
            final selectedCatImage = catImages[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    PageTransition(
                        duration: const Duration(milliseconds: 200),
                        reverseDuration: const Duration(milliseconds: 200),
                        type: PageTransitionType.rightToLeft,
                        child: CatProfileView(
                            catImage: selectedCatImage,
                            cat: selectedCat
                        )
                    )
                );
                Provider.of<CatListViewModel>(context, listen: false).selectedCat = selectedCat;
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 125,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(25.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 4),
                      )
                    ]),
                child: Row(
                    children: [
                      Container(
                          height: 125,
                          width: 115,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(20.0)),
                            image: DecorationImage(
                                image: selectedCatImage.url != ""
                                    ? selectedCatImage
                                    : defaultCatImage,
                                fit: BoxFit.cover),
                          )
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
            );
          }),
    );
  }
}
