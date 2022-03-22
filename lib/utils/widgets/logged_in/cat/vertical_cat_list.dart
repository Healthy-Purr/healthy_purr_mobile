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
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final catList =
        Provider.of<CatListViewModel>(context, listen: false).getCats();

    final catImages =
        Provider.of<CatListViewModel>(context, listen: false).getCatsImages();

    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: catList.length,
          itemBuilder: (context, index) {

            final selectedCat = catList[index];
            final selectedCatImage = catImages[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 125,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: Ink(
                      child: InkWell(
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
                        },
                        child: Container(
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
                      ),
                    ),
                  ),
                  Positioned(
                    left: 115,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: 185,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(selectedCat.name!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text.rich(TextSpan(children: [
                            const TextSpan(text: 'Edad: '),
                            TextSpan(
                                text: selectedCat.age.toString(),
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text: ' años',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold))
                          ])),
                          Text.rich(TextSpan(children: [
                            const TextSpan(text: 'Peso: '),
                            TextSpan(
                                text: selectedCat.weight.toString(),
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text: ' kg',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold))
                          ])),
                          selectedCat.gender.toString() == 'true'
                              ? const Text.rich(TextSpan(children: [
                                  TextSpan(text: 'Sexo: '),
                                  TextSpan(
                                      text: 'Macho',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]))
                              : const Text.rich(TextSpan(children: [
                                  TextSpan(text: 'Sexo: '),
                                  TextSpan(
                                      text: 'Hembra',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ]))
                        ]
                            .map((children) => Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: children))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
