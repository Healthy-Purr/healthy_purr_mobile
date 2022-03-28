
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/view_models/camera_view_models/camera_view_model.dart';
import 'package:provider/provider.dart';

import '../../../utils/constants/constants.dart';
import 'checking_message_view.dart';

class PhotosListView extends StatefulWidget {

  const PhotosListView({Key? key}) : super(key: key);

  @override
  _PhotosListViewState createState() => _PhotosListViewState();
}

enum ContainerColors {first, second}

class _PhotosListViewState extends State<PhotosListView> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

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
              top: MediaQuery.of(context).viewPadding.top + 40, //logo size
              bottom: 0, right: 0, left: 0,
              child: const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: CheckingMessageView(text: 'Espera un momento por favor, se está comparando las comidas.',),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 200, //logo size
              bottom: 0, right: 0, left: 0,
              child: Column(
                children: [
                  Center(
                    child: Wrap(
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: List.generate(Provider.of<CameraViewModel>(context, listen: false).getPhotos().length, (index) =>
                          SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                                    height: 170,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                      image: DecorationImage(image: FileImage(Provider.of<CameraViewModel>(context, listen: false).getPhotos()[index]), fit: BoxFit.fill),
                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Comida ${index + 1}', style: const TextStyle(fontSize: 12),),
                                      const SizedBox(
                                        width: 10,
                                        height: 10,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: evaluationOption,),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

  }
}
