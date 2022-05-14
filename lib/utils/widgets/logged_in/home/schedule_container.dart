import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../models/entities/schedule_meal.dart';
import '../../../../view_models/schedule_view_models/schedule_list_view_model.dart';
import '../../../constants/constants.dart';
import '../../../daily_function.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;

    final scheduleList = Provider.of<ScheduleListViewModel>(context).getTodayScheduleList();

    return Container(
      width: MediaQuery.of(context).size.width,
      height: screenSize.height * 0.43,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xfff8f8f8),
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 8),

              //TODO: ADD CAT SCHEDULES

            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate((MediaQuery.of(context).size.width * 0.047).round(), (index) => const Padding(
              padding: EdgeInsets.all(5.0),
              child: CircleAvatar(backgroundColor: Colors.grey, radius: 3,),
            ))
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getTodayWeekDay(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Column(
                children: [
                  Text(getTodayMonth(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
                  Text(getTodayDay(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
            ],
          ),
          scheduleList.isNotEmpty ? SizedBox(
            height: screenSize.height * 0.28,
            width: screenSize.width * 0.6,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: scheduleList.length,
              itemBuilder: (context, index) {

                final ScheduleMeal selectedSchedule = scheduleList[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 15),
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
                          height: 55,
                          width: screenSize.width * 0.2,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.horizontal(right: Radius.circular(20.0)),
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
                );
              },
            ),
          ) : SizedBox(
              height: screenSize.height * 0.28,
              width: screenSize.width * 0.8,
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
              ))
        ],
      ),
    );
  }
}
