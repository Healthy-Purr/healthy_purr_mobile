import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:bordered_text/bordered_text.dart';

class HorizontalCatList extends StatefulWidget {
  const HorizontalCatList({Key? key}) : super(key: key);

  @override
  _HorizontalCatListState createState() => _HorizontalCatListState();
}

class _HorizontalCatListState extends State<HorizontalCatList> {
  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    final catList = Provider.of<CatListViewModel>(context).getCats();

    final catImages = Provider.of<CatListViewModel>(context, listen: false).getCatsImages();

    return SizedBox(
      height: 160,
      width: screenSize.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: catList.length,
        itemBuilder: (context, index) {

          final CatViewModel selectedCat = catList[index];
          var selectedCatImage = catImages[index];

          if(selectedCat.status == true) {
            return Container(
              margin: const EdgeInsets.only(right: 16, bottom: 10),
              height: 180,
              width: 105,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 7),
                    )
                  ]
              ),
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          PageTransition(
                              duration: const Duration(milliseconds: 200),
                              reverseDuration: const Duration(milliseconds: 200),
                              type: PageTransitionType.rightToLeft,
                              child: CatProfileView(
                                  index: index,
                                  catImage: selectedCatImage,
                                  cat: selectedCat
                              )
                          )
                      ).whenComplete((){
                        setState(() {

                        });
                      });
                      Provider.of<CatListViewModel>(context, listen: false).selectedCat = selectedCat;
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                      height: 170,
                      width: 99,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                        image: DecorationImage(
                            image: Provider.of<CatListViewModel>(context).getCatsImages()[index],
                            fit: BoxFit.cover),
                      ),

                    ),
                  ),
                  Positioned(
                    bottom: 10, left: 14,
                    child: BorderedText(
                      strokeColor: Colors.black26,
                      strokeWidth: 2.0,
                      child: Text(selectedCat.name!,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            );
          }
          else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
