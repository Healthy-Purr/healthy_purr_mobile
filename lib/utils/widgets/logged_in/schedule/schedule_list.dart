import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthy_purr_mobile_app/models/dtos/schedule_meal_dto.dart';
import 'package:healthy_purr_mobile_app/models/entities/day.dart';
import 'package:healthy_purr_mobile_app/view_models/schedule_view_models/schedule_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../models/entities/schedule_meal.dart';
import '../../../../view_models/schedule_view_models/schedule_list_view_model.dart';
import '../../../constants/constants.dart';

class ScheduleList extends StatefulWidget {
  const ScheduleList({Key? key}) : super(key: key);

  @override
  _ScheduleListState createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes";
  }

  _showDialog(Size size, int index){
    showDialog(
      barrierColor: Colors.white.withOpacity(0.9),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          contentPadding: EdgeInsets.zero,
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Provider.of<ScheduleListViewModel>(context, listen: false).cleanUpdateFields();
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
            ElevatedButton(
              child: const Text('Actualizar'),
              onPressed: () async {
                Provider.of<ScheduleListViewModel>(context, listen: false).updateScheduleMeal(index).whenComplete((){
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
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
                              Provider.of<ScheduleListViewModel>(context).getTimeToUpdate().inMinutes > 0 ?
                              _printDuration(Provider.of<ScheduleListViewModel>(context).getTimeToUpdate()) :
                              Provider.of<ScheduleListViewModel>(context).getSelectedScheduleMealDto().hour!.substring(0, Provider.of<ScheduleListViewModel>(context).getSelectedScheduleMealDto().hour!.length - 3),
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
                    height: 200,
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
                                              backgroundColor: Provider.of<ScheduleListViewModel>(context).newDryFood ? primaryColor : Colors.grey.withOpacity(0.3),
                                              child: InkWell(
                                                  onTap: (){
                                                    Provider.of<ScheduleListViewModel>(context, listen: false).updateDryFood();
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
                                              backgroundColor: Provider.of<ScheduleListViewModel>(context).newDampFood ? primaryColor : Colors.grey.withOpacity(0.3),
                                              child: InkWell(
                                                  onTap: (){
                                                    Provider.of<ScheduleListViewModel>(context, listen: false).updateDampFood();
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
                                              backgroundColor: Provider.of<ScheduleListViewModel>(context).newMedicine ? primaryColor : Colors.grey.withOpacity(0.3),
                                              child: InkWell(
                                                  onTap: (){
                                                    Provider.of<ScheduleListViewModel>(context, listen: false).updateMedicine();
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
                            initialTimerDuration: Duration(hours: int.parse(Provider.of<ScheduleListViewModel>(context, listen: false).getSelectedScheduleMealDto().hour!.substring(0,2)), minutes: int.parse(Provider.of<ScheduleListViewModel>(context, listen: false).getSelectedScheduleMealDto().hour!.substring(3,5))),
                            minuteInterval: 5,
                            mode: CupertinoTimerPickerMode.hm,
                            onTimerDurationChanged: (duration){
                              Provider.of<ScheduleListViewModel>(context, listen: false).setTimeToUpdate(duration);
                            }
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    final scheduleList = Provider.of<ScheduleListViewModel>(context).getScheduleListByDay();

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.03, horizontal: screenSize.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Provider.of<ScheduleListViewModel>(context).selectedDay.name!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          scheduleList.isNotEmpty ? SizedBox(
            height: screenSize.height * 0.6,
            width: screenSize.width * 0.6,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: scheduleList.length,
              itemBuilder: (context, index) {

                final ScheduleMeal selectedSchedule = scheduleList[index];

                return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 60,
                    width: screenSize.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
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
                                            Provider.of<ScheduleListViewModel>(context, listen: false).deleteScheduleMeal(index,selectedSchedule).whenComplete((){
                                              Navigator.pop(context);
                                            });
                                            // Provider.of<CatService>(context, listen: false).deleteCat(selectedCat).then((value){
                                            //   if(value) {
                                            //     Provider.of<CatListViewModel>(context, listen: false).deleteCat(selectedCat);
                                            //   }
                                            // }).whenComplete((){
                                            //   Navigator.pop(context);
                                            //   NotificationService().showNotification(
                                            //       context,
                                            //       catDeleteSuccessful,
                                            //       "success");
                                            // });
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
                      child: GestureDetector(
                        onTap: (){
                          Provider.of<ScheduleListViewModel>(context, listen: false).setScheduleMealDto(selectedSchedule);
                          Provider.of<ScheduleListViewModel>(context, listen: false).setTimeToUpdateBefore(Duration(hours: int.parse(Provider.of<ScheduleListViewModel>(context, listen: false).getSelectedScheduleMealDto().hour!.substring(0,2)), minutes: int.parse(Provider.of<ScheduleListViewModel>(context, listen: false).getSelectedScheduleMealDto().hour!.substring(3,5))));
                          _showDialog(screenSize, index);
                        },
                        child: SizedBox(
                          width: screenSize.width * 0.6,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: screenSize.width * 0.4,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.horizontal(left: Radius.circular(20.0)),
                                  color: Color(0xFFFFF5E3),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Visibility(
                                        visible: selectedSchedule.isDry! ,
                                        child: Image.asset('assets/images/cat_dry_food.png', height: 40,)
                                    ),
                                    Visibility(
                                        visible: selectedSchedule.isDamp! ,
                                        child: Image.asset('assets/images/cat_can.png', height: 40)
                                    ),
                                    Visibility(
                                        visible: selectedSchedule.hasMedicine! ,
                                        child: Image.asset('assets/images/cat_medicine.png', height: 40)
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(right: 15),
                                  width: screenSize.width * 0.2,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFBFBFB),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(selectedSchedule.hour!.length > 8 ?
                                    selectedSchedule.hour!.substring(0, selectedSchedule.hour!.length - 6) :
                                      selectedSchedule.hour!.substring(0, selectedSchedule.hour!.length - 3), textAlign: TextAlign.end, style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ) : SizedBox(
            height: screenSize.height * 0.6,
            width: screenSize.width * 0.6,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      RotationTransition(
                          turns: AlwaysStoppedAnimation(340 / 360),
                          child: FaIcon(FontAwesomeIcons.paw, color: primaryColor.withOpacity(0.2), size: 60,)),
                      Text('No tiene horarios este día', style: TextStyle(color: Colors.grey),),
                    ],
                  )
                ],
            ),
          ),
        ],
      ),
    );
  }
}