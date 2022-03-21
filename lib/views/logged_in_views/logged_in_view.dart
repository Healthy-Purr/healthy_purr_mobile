import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/providers/provider.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';
import 'package:healthy_purr_mobile_app/utils/util.dart';
import 'package:healthy_purr_mobile_app/view_models/view_model.dart';
import 'package:healthy_purr_mobile_app/views/view.dart';
import 'package:provider/provider.dart';

class LoggedInView extends StatefulWidget {
  static const routeName = "/home";
  const LoggedInView({Key? key}) : super(key: key);

  @override
  _LoggedInViewState createState() => _LoggedInViewState();
}

class _LoggedInViewState extends State<LoggedInView> {

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
      floatingActionButton: const GradientFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            child: Image.asset('assets/images/top-right_decoration.png',
                height: 400, alignment: Alignment.topLeft, fit: BoxFit.contain),
          ),
          Positioned(
            left: 25, top: MediaQuery.of(context).viewPadding.top,
            child: Image.asset('assets/images/safety_purr_logocolor.png',
                height: 35, alignment: Alignment.topLeft, fit: BoxFit.contain),
          ),
          Positioned(
            right: 0, top: MediaQuery.of(context).viewPadding.top,
            child: const GoToProfileButton(),
          ),
          Positioned(
            top: 80, bottom: 90, right: 25, left: 25,
            child: FutureBuilder(
              future: Future.wait([
                Provider.of<HeadersService>(context, listen: false).setHeaders(),
                Provider.of<UserViewModel>(context, listen: false).setUserInformation(),
                Provider.of<CatListViewModel>(context, listen: false).populateCatList(context),
                Provider.of<CatListViewModel>(context, listen: false).populateCatsImages(context),
              ]),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.done) {
                  return IndexedStack(
                      index: bottomNavigationBarProvider.pageIndex,
                      children: const [
                        HomeView(),
                        Text('2'),
                        Text('3'),
                        Text('4'),
                      ]
                    //     .map((children) => RefreshIndicator(onRefresh: _refresh,
                    //     child: children)).toList(),
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
