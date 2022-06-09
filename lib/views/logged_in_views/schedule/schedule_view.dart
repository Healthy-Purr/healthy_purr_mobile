import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/constants/constants.dart';
import 'package:healthy_purr_mobile_app/view_models/cat_view_models/cat_view_model.dart';
import 'package:healthy_purr_mobile_app/view_models/schedule_view_models/schedule_list_view_model.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

import '../../../models/entities/day.dart';
import '../../../utils/widgets/logged_in/schedule/schedule_list.dart';
import '../../../view_models/cat_view_models/cat_list_view_model.dart';

class ScheduleView extends StatefulWidget {

  const ScheduleView({Key? key}) : super(key: key);

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

enum ContainerColors {first, second}

class _ScheduleViewState extends State<ScheduleView> with TickerProviderStateMixin{

  //ESTA MIERDA ESTÁ EN DURO, FEO PERO NECESARIO PORQUE
  //EL MONGOLO QUE HIZO MI BACKEND NOS ENTENDIÓ MAL,
  //QUÉ IMPORTA, IGUAL FUNCIONA

  final List<MealDay> _days = [MealDay(0, 'Lunes', 'L', DateTime(2022, 5, 2)), MealDay(1, 'Martes', 'M', DateTime(2022, 5, 3)), MealDay(2, 'Miercoles', 'X', DateTime(2022, 5, 4)),
    MealDay(3, 'Jueves', 'J', DateTime(2022, 5, 5)), MealDay(4, 'Viernes', 'V', DateTime(2022, 5, 6)), MealDay(5, 'Sabado', 'S', DateTime(2022, 5, 7)), MealDay(6, 'Domingo', 'D', DateTime(2022, 5, 1))];
  int _selected = 0;

  PageController _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void dispose(){
    _pageController;
    super.dispose();
  }

  late AnimationController scaleController = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  _registerSuccess(Size size){

    double circleSize = 100;
    double iconSize = 100;

    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();

    Future.delayed(const Duration(seconds: 2)).whenComplete((){
      Navigator.pop(context);
    });

    showDialog(
      barrierColor: Colors.white.withOpacity(0.9),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('El registro se completó con éxito', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center,),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 300.0,
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: 300.0,
                    height: 180,
                    child: Stack(
                      children: [
                        Center(
                          child: ScaleTransition(
                            scale: scaleAnimation,
                            child: Container(
                              height: circleSize,
                              width: circleSize,
                              decoration: const BoxDecoration(
                                color: addCatScheduleButtonColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        SizeTransition(
                          sizeFactor: checkAnimation,
                          axis: Axis.horizontal,
                          axisAlignment: -1,
                          child: Center(
                            child: Icon(Icons.check_rounded, color: Colors.white, size: iconSize),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          bottom: 0,
                          child: Image.asset('assets/images/cat_2_cropped.png', height: 70,))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete((){
      scaleController.reset();
      checkController.reset();
    });
  }

  _showValidateDialog(Size size){
    showDialog(
      barrierColor: Colors.white.withOpacity(0.9),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cuidado!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center,),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          actions: [

          ],
          content: Container(
            width: 300.0,
            height: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
              child: SizedBox(
                width: 300.0,
                height: 150,
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    const Positioned(
                      top: 20,
                      child: SizedBox(
                          width: 250,
                          child: Text('Debes registrar por lo menos un gato para continuar', style: TextStyle(fontSize: 12), textAlign: TextAlign.center,))),
                    Positioned(
                        top: 80,
                        left: 10,
                        bottom: 0,
                        child: Image.asset('assets/images/cat_2_cropped.png', height: 70,)),
                    Positioned(
                      right: 10,
                      bottom: 0,
                      child: ElevatedButton(
                        child: const Text('Aceptar'),
                        onPressed: () {
                          Provider.of<ScheduleListViewModel>(context, listen: false).cleanUpdateFields();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _showDialog(Size size){
    List<bool> _validators = [false, false, false];

    showDialog(
      barrierColor: Colors.white.withOpacity(0.9),
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Provider.of<ScheduleListViewModel>(context, listen: false).cleanUpdateFields();
            Provider.of<ScheduleListViewModel>(context, listen: false).cleanDto();
            return true;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            contentPadding: EdgeInsets.zero,
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              ElevatedButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Provider.of<ScheduleListViewModel>(context, listen: false).cleanUpdateFields();
                  Provider.of<ScheduleListViewModel>(context, listen: false).cleanDto();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: cancelButtonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)
                    )
                ),
              ),
              AbsorbPointer(
                absorbing:  _validators.where((element) => element == false).length == 3 ? true : false,
                child: ElevatedButton(
                  child: const Text('Registrar'),
                  onPressed: _validators.where((element) => element == false).length == 3 ? null : () async {
                    Provider.of<ScheduleListViewModel>(context, listen: false).registerSchedule(context).whenComplete((){
                      Navigator.pop(context);
                      _registerSuccess(size);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      )
                  ),
                ),
              )
            ].map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: e,
            )).toList(),
            content: Container(
              width: 300.0,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          right: 0,
                          child: InkWell(
                            child: Container(
                              width: size.width * 0.5,
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 30),
                              decoration: BoxDecoration(
                                color: Color(0xFFFBFBFB),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.0)),
                              ),
                              child: Text(
                                _printDuration(Provider.of<ScheduleListViewModel>(context).getTimeToRegister()),
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.5,
                          padding: EdgeInsets.only(left: 30, top: 15.0, bottom: 15.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0)),
                          ),
                          child: Text(
                            Provider.of<ScheduleListViewModel>(context, listen: false).selectedDay.name!,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 250,
                      width: 300,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (int index) {
                          _currentPageNotifier.value = index;
                        },
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0, ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/cat_dry_food.png', height: 40,),
                                    Container(
                                      width: size.width * 0.5,
                                      padding: const EdgeInsets.only(left: 15),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                          color: Color(0xFFFAFAFA)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text('Comida seca', style: TextStyle(fontSize: 12)),
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Provider.of<ScheduleListViewModel>(context).getScheduleMealToRegister().isDry! ? primaryColor : Colors.grey.withOpacity(0.3),
                                            child: InkWell(
                                                onTap: (){
                                                  Provider.of<ScheduleListViewModel>(context, listen: false).selectDryFood();
                                                  setState(() {
                                                    _validators[0] = !_validators[0];
                                                  });
                                                },
                                                child: Icon(Icons.check, size: 30, color: Colors.white,)
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/cat_can.png', height: 40,),
                                    Container(
                                      width: size.width * 0.5,
                                      padding: const EdgeInsets.only(left: 15),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                          color: Color(0xFFFAFAFA)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text('Comida humeda', style: TextStyle(fontSize: 12)),
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Provider.of<ScheduleListViewModel>(context).getScheduleMealToRegister().isDamp! ? primaryColor : Colors.grey.withOpacity(0.3),
                                            child: InkWell(
                                                onTap: (){
                                                  Provider.of<ScheduleListViewModel>(context, listen: false).selectDampFood();
                                                  setState(() {
                                                    _validators[1] = !_validators[1];
                                                  });
                                                },
                                              child: Icon(Icons.check, size: 30, color: Colors.white,)
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/cat_medicine.png', height: 40,),
                                    Container(
                                      width: size.width * 0.5,
                                      padding: const EdgeInsets.only(left: 15),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                          color: Color(0xFFFAFAFA)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text('Medicina', style: TextStyle(fontSize: 12)),
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: Provider.of<ScheduleListViewModel>(context).getScheduleMealToRegister().hasMedicine! ? primaryColor : Colors.grey.withOpacity(0.3),
                                            child: InkWell(
                                                onTap: (){
                                                  Provider.of<ScheduleListViewModel>(context, listen: false).selectMedicine();
                                                  setState(() {
                                                    _validators[2] = !_validators[2];
                                                  });
                                                },
                                              child: Icon(Icons.check, size: 30, color: Colors.white,)
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ]
                            )
                          ),
                          CupertinoTimerPicker(
                            minuteInterval: 5,
                            mode: CupertinoTimerPickerMode.hm,
                            onTimerDurationChanged: (duration){
                              Provider.of<ScheduleListViewModel>(context, listen: false).setTimeToRegister(duration);
                            }
                          )
                        ],
                      ),
                    ),
                    CirclePageIndicator(
                      itemCount: 2,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Horario',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.01, horizontal: 5),
              height: screenSize.height * 0.73,
              width: screenSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 7),
                    )
                ]
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_days.length, (index){
                      return InkWell(
                        onTap: (){
                          Provider.of<ScheduleListViewModel>(context, listen: false).setSelectedDay(_days[index]);
                          setState(() {
                            _selected = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            color: _selected == index ? primaryColor : Colors.white,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))
                          ),
                          child: Text(_days[index].abr!, style: TextStyle(fontSize: 15, color: _selected == index ? Colors.white : Colors.black, fontWeight: FontWeight.bold),),
                        ),
                      );
                    })
                  ),
                  SizedBox(
                    height: screenSize.height,
                    child: const DottedLine(
                      dashColor: primaryColor,
                      direction: Axis.vertical,
                      dashLength: 15,
                      dashGapLength: 25,
                      lineThickness: 2,
                    ),
                  ),
                  const ScheduleList()
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: screenSize.height * 0.04,
              child: GestureDetector(
                onTap: (){
                  if(Provider.of<CatListViewModel>(context, listen: false).getCats().isEmpty){
                    _showValidateDialog(screenSize);
                  }
                  else{
                    _showDialog(screenSize);
                  }
                },
                child: Container(
                  height: 50.0,
                  width: 140.0,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(10.0), left: Radius.circular(30.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Añadir Horario', style: TextStyle(color: Colors.white),)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}