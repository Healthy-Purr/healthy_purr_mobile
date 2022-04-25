import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_purr_mobile_app/utils/constants/constants.dart';
import 'package:healthy_purr_mobile_app/view_models/schedule_view_models/schedule_list_view_model.dart';
import 'package:provider/provider.dart';

import '../../../models/entities/day.dart';
import '../../../utils/widgets/logged_in/schedule/schedule_list.dart';

class ScheduleView extends StatefulWidget {

  const ScheduleView({Key? key}) : super(key: key);

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

enum ContainerColors {first, second}

class _ScheduleViewState extends State<ScheduleView> {

  final List<Day> _days = [Day(1, 'Lunes', 'L', DateTime(2022, 5, 2)), Day(2, 'Martes', 'M', DateTime(2022, 5, 3)), Day(3, 'Miercoles', 'X', DateTime(2022, 5, 4)),
    Day(4, 'Jueves', 'J', DateTime(2022, 5, 5)), Day(5, 'Viernes', 'V', DateTime(2022, 5, 6)), Day(6, 'Sabado', 'S', DateTime(2022, 5, 7)), Day(0, 'Domingo', 'D', DateTime(2022, 5, 1))];
  int _selected = 0;


  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  _showDialog(Size size){
    showDialog(
      barrierColor: Colors.white.withOpacity(0.9),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          contentPadding: EdgeInsets.zero,
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
                    height: 300,
                    width: 300,
                    child: PageView(
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
                  ElevatedButton(onPressed: (){ Provider.of<ScheduleListViewModel>(context, listen: false).registerSchedule(context).whenComplete((){
                    Navigator.pop(context);
                  }); }, child: Text('Registrar'))
                ],
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

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.05, horizontal: 5),
          height: screenSize.height,
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
              ScheduleList()
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: screenSize.height * 0.07,
          child: GestureDetector(
            onTap: (){
              _showDialog(screenSize);
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
    );
  }
}