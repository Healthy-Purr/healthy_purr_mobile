import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/camera_view_models/camera_view_model.dart';
import 'package:healthy_purr_mobile_app/views/logged_in_views/camera/photos_list_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class CameraView extends StatefulWidget {
  final CameraDescription camera;
  const CameraView({required this.camera, Key? key}) : super(key: key);

  @override
  CameraViewState createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    SchedulerBinding.instance?.addPostFrameCallback((_) => _showDialog());
  }

  _showDialog(){
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 285),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tome una foto a los ingredientes y análisis garantizado de la comida para gatos',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.justify,),
                  Image .asset('assets/images/take_photo_example.png'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () { Navigator.pop(context); },
                        child: const Text('No volver a mostrar', style: TextStyle(fontSize: 12, color: Colors.grey),),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            side: const BorderSide(width: 2.0, color: complementaryColor)),
                        onPressed: (){},
                        child: const Text('Continuar', style: TextStyle(color: complementaryColor, fontWeight: FontWeight.w500),)
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _selectOption(XFile photo){
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 285),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tome una foto a los ingredientes y análisis garantizado de la comida para gatos',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.justify,),
                  Image.asset('assets/images/select_option.png'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              side: const BorderSide(width: 2.0, color: complementaryColor)),
                          onPressed: (){
                            Provider.of<CameraViewModel>(context, listen: false).addPhotoAfterShoot(File(photo.path));
                            Navigator.pop(context);
                          },
                          child: const Text('Comparar', style: TextStyle(color: complementaryColor, fontWeight: FontWeight.w500),)
                      ),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              side: const BorderSide(width: 2.0, color: evaluationOption)),
                          onPressed: (){},
                          child: const Text('Evaluar', style: TextStyle(color: evaluationOption, fontWeight: FontWeight.w500),)
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future pickImage(ImageSource source) async {
    var images = await ImagePicker().pickMultiImage();
    Provider.of<CameraViewModel>(context, listen: false).setPhotosFromGallery(images!);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Material(
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: CameraPreview(controller),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height/20),
              child: GradientFloatingActionButton(onTap: () async {
                if(Provider.of<CameraViewModel>(context, listen: false).getPhotos().isNotEmpty){
                  await controller.takePicture().then((photo){
                    Provider.of<CameraViewModel>(context, listen: false).addPhotoAfterShoot(File(photo.path));
                  });
                }
                else{
                  await controller.takePicture().then((photo){
                    _selectOption(photo);
                  });
                }
              }, width: 100, height: 100,),
            )
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: size.height/20, left: 50),
                child: InkWell(
                  onTap: (){
                    pickImage(ImageSource.gallery);
                  },
                  child: const Icon(
                    Icons.image_rounded, color: Colors.white, size: 50,
                  ),
                ),
              )
          ),
          AnimatedPositioned(
              width: 140,
              bottom: 5.0,
              right: Provider.of<CameraViewModel>(context).getPhotos().isNotEmpty ? 0.0 : -150.0,
              curve: Curves.fastOutSlowIn,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height/20),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context,
                          PageTransition(
                              duration: const Duration(milliseconds: 200),
                              reverseDuration: const Duration(milliseconds: 200),
                              type: PageTransitionType.rightToLeft,
                              child: const PhotosListView()
                          )
                      );
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
                      decoration: const BoxDecoration(
                          color: updateCatInformationButtonColor,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), bottomLeft: Radius.circular(25.0))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Continuar', style: TextStyle(fontSize: 12, color: Colors.white),),
                          Container(
                            width: 30,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                            ),
                            child: Center(
                              child: Text(Provider.of<CameraViewModel>(context).getPhotos().length.toString(), style: const TextStyle(fontSize: 12, color: Colors.black),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              duration: const Duration(seconds: 2)
          ),
          //Android/iOS
          // Image.file(File(pictureFile!.path)))
        ],
      ),
    );
  }
}