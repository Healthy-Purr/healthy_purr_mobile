import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Container(
      width: MediaQuery.of(context).size.width,
      height: 325,
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
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate((MediaQuery.of(context).size.width * 0.05).round(), (index) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(backgroundColor: Colors.black, radius: 3,),
            ))
          )
        ],
      ),
    );
  }
}
