import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
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
      height: screenSize.height,
      width: screenSize.width,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: catList.length,
          itemBuilder: (context, index) {

            final CatViewModel selectedCat = catList[index];
            final selectedCatImage = catImages[index];

            if(selectedCat.status == true) {
              return GestureDetector(
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
                  );
                  Provider.of<CatListViewModel>(context, listen: false).selectedCat = selectedCat;
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
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 4),
                        )
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        extentRatio: 0.30,
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(deleteCatAlertDialogTitle, style: TextStyle(fontSize: 18.0), textAlign: TextAlign.justify),
                                      content: const Text(deleteCatAlertDialogContent, style: TextStyle(fontSize: 14.0), textAlign: TextAlign.justify),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25.0)
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          child: const Text(deleteCatAlertDialogConfirmAction),
                                          onPressed: () async {
                                            Provider.of<CatService>(context, listen: false).deleteCat(selectedCat).then((value){
                                              if(value) {
                                                Provider.of<CatListViewModel>(context, listen: false).deleteCat(selectedCat);
                                              }
                                            }).whenComplete((){
                                              Navigator.pop(context);
                                              NotificationService().showNotification(
                                                  context,
                                                  catDeleteSuccessful,
                                                  "success");
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25.0)
                                            )
                                          ),
                                        ),
                                        ElevatedButton(
                                          child: const Text(deleteCatAlertDialogDismissAction),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25.0)
                                            )
                                          ),
                                        )
                                      ].map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: e,
                                      )).toList(),
                                    );
                                  }
                              );
                            },
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: 'Eliminar',
                          )
                        ],
                      ),
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
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
