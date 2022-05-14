import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/utils/widgets/evaluation/select_cat_list.dart';
import 'package:healthy_purr_mobile_app/view_models/camera_view_models/camera_view_model.dart';
import 'package:healthy_purr_mobile_app/views/logged_in_views/camera/photos_list_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../evaluation/select_cat_view.dart';


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
    controller.setFlashMode(FlashMode.off);
    SchedulerBinding.instance?.addPostFrameCallback((_) => _showDialog());
  }

  _showDialog(){
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          ),
          title: const Text(
            cameraInstructionAlertDialogTitle,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.justify
          ),
          content: Image.asset(
            photoInstructionImageAsset,
            width: 120, height: 120,
            fit: BoxFit.contain,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black
              ),
              onPressed: () { Navigator.pop(context); },
              child: const Text(cameraInstructionDoNotShowAgain, style: TextStyle(fontSize: 12, color: Colors.grey),),
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.pink[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  side: const BorderSide(width: 2.0, color: complementaryColor)
                ),
                onPressed: (){},
                child: const Text(cameraInstructionConfirmAction, style: TextStyle(color: complementaryColor, fontWeight: FontWeight.w500),)
            )
          ],
        );
      },
    );
  }

  _preVisualizePhoto(XFile photo){

    File toSend = File(photo.path);

    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          ),
          title: const Text(
              '¿Desea continuar con esta foto?',
              style: TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center),
          content: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: Image.file(
                toSend, width: 600, height: 500, fit: BoxFit.contain,
              )
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12.5),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE3575D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text('Tomar otra', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: (){
                  if(Provider.of<CameraViewModel>(context, listen: false).getPhotos().isNotEmpty){
                    Provider.of<CameraViewModel>(context, listen: false).addPhotoAfterShoot(toSend);
                    Navigator.pop(context);
                  }
                  else{
                    Navigator.pop(context);
                    _selectOption(photo);
                  }
                },
                child: const Text('Continuar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)
            )
          ],
        );
      },
    );
  }


  _selectOption(XFile photo){
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          ),
          title: const Text(
            selectOptionAlertDialogTitle,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.justify),
          content: Image.asset(
            selectOptionInstructionImageAsset,
            width: 230, height: 145,
            fit: BoxFit.contain,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(horizontal: 12.5),
          actions: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.pink[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  side: const BorderSide(width: 2.0, color: complementaryColor)
                ),
                onPressed: (){
                  Provider.of<CameraViewModel>(context, listen: false).addPhotoAfterShoot(File(photo.path));
                  Navigator.pop(context);
                },
                child: const Text(selectOptionCompareAction, style: TextStyle(color: complementaryColor, fontWeight: FontWeight.w500),)
            ),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.red[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  side: const BorderSide(width: 2.0, color: evaluationOption)
                ),
                onPressed: (){
                  Provider.of<CameraViewModel>(context, listen: false).addPhotoAfterShoot(File(photo.path));
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      PageTransition(
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                          type: PageTransitionType.rightToLeft,
                          child: const SelectCatView()
                      )
                  );
                },
                child: const Text(selectOptionEvaluateAction, style: TextStyle(color: evaluationOption, fontWeight: FontWeight.w500),)
            )
          ],
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
                await controller.takePicture().then((photo){
                  _preVisualizePhoto(photo);
                });
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
                      Navigator.pushReplacement(context,
                          PageTransition(
                              duration: const Duration(milliseconds: 200),
                              reverseDuration: const Duration(milliseconds: 200),
                              type: PageTransitionType.rightToLeft,
                              child: const SelectCatView()
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