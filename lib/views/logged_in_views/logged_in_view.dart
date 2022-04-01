import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/providers/provider.dart';
import 'package:healthy_purr_mobile_app/services/camera_service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:healthy_purr_mobile_app/views/logged_in_views/camera/camera_view.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoggedInView extends StatefulWidget {
  static const routeName = "/home";
  const LoggedInView({Key? key}) : super(key: key);

  @override
  _LoggedInViewState createState() => _LoggedInViewState();
}

class _LoggedInViewState extends State<LoggedInView> {

  late var _future;

  @override
  void initState() {
    _future = Provider.of<CatListViewModel>(context, listen: false).populateCatList(context).whenComplete(() =>
        Provider.of<CatListViewModel>(context, listen: false).populateCatsImages(context).whenComplete(() {
          Provider.of<DiseaseListViewModel>(context, listen: false).populateDiseaseList().whenComplete(() =>
            Provider.of<AllergyListViewModel>(context, listen: false).populateAllergyList().whenComplete(() =>
              Provider.of<UserViewModel>(context, listen: false).setUserImage()
            )
          );
        }
      )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final bottomNavigationBarProvider = Provider.of<BottomNavigationBarProvider>(context);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CustomBottomNavigationBar(
        index: bottomNavigationBarProvider.pageIndex,
        onChangedTab: (index){
          bottomNavigationBarProvider.setPageIndex(index);
        },
      ),
      floatingActionButton: GradientFloatingActionButton(
        height: 75,
        width: 75,
        onTap: () async {
          await CameraService().getCameras().then((camera){
            Navigator.push(context,
                PageTransition(
                    duration: const Duration(milliseconds: 200),
                    reverseDuration: const Duration(milliseconds: 200),
                    type: PageTransitionType.bottomToTop,
                    child: CameraView(camera: camera)
                )
            );
          });
      },),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            child: Image.asset(topRightDecoration, height: 400,
                alignment: Alignment.topLeft, fit: BoxFit.contain
            ),
          ),
          Positioned(
            left: 25, top: MediaQuery.of(context).viewPadding.top,
            child: Image.asset(healthyPurrLogo, height: 35,
                alignment: Alignment.topLeft, fit: BoxFit.contain),
          ),
          Positioned(
            right: 0, top: MediaQuery.of(context).viewPadding.top,
            child: const GoToProfileButton(),
          ),
          Positioned(
            top: 80, bottom: 90, right: 25, left: 25,
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return IndexedStack(
                      index: bottomNavigationBarProvider.pageIndex,
                      children: const [
                        HomeView(),
                        CatsView(),
                        Text('3'),
                        Text('4'),
                      ]
                  );
                } else {
                  return const Center(child: CupertinoActivityIndicator());
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}
