
import 'package:flutter/cupertino.dart';
import 'package:healthy_purr_mobile_app/models/entities/schedule.dart';
import 'package:healthy_purr_mobile_app/models/entities/schedule_meal.dart';
import 'package:healthy_purr_mobile_app/services/schedule_service.dart';
import 'package:healthy_purr_mobile_app/view_models/cat_view_models/cat_list_view_model.dart';
import 'package:healthy_purr_mobile_app/view_models/schedule_view_models/schedule_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/dtos/schedule_meal_dto.dart';
import '../../models/entities/day.dart';


class FoodOption{
  String? name;
  String? image;
  bool selected = false;

  FoodOption(this.name, this.image, this.selected);
}

class ScheduleListViewModel extends ChangeNotifier {

  final List<ScheduleViewModel?> _scheduleList = [null, null, null, null, null, null, null];

  final ScheduleService _scheduleService = ScheduleService();

  late ScheduleViewModel selectedSchedule;

  late ScheduleMeal _selectedScheduleMealDto;

  Duration _timeToRegister = const Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0);

  Duration _timeToUpdate = const Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0);

  Day selectedDay = Day(1, 'Lunes', 'L', DateTime(2022, 5, 2));

  bool _registering = false;

  ScheduleMeal _scheduleMealToRegister = ScheduleMeal.fromScheduleMeal(0, '', '00:00:00:00', false, false, false, 0, false);

  ScheduleMeal getSelectedScheduleMealDto(){
    return _selectedScheduleMealDto;
  }

  setScheduleMealDto(ScheduleMeal newSchedule){
    _selectedScheduleMealDto = newSchedule;
    notifyListeners();
  }

  selectDryFood(){
    _scheduleMealToRegister.isDry = !_scheduleMealToRegister.isDry!;
    notifyListeners();
  }

  selectDampFood(){
    _scheduleMealToRegister.isDamp = !_scheduleMealToRegister.isDamp!;
    notifyListeners();
  }

  selectMedicine(){
    _scheduleMealToRegister.hasMedicine = !_scheduleMealToRegister.hasMedicine!;
    notifyListeners();
  }

  ScheduleMeal getScheduleMealToRegister(){
    return _scheduleMealToRegister;
  }

  Duration getTimeToRegister(){
    return _timeToRegister;
  }

  setTimeToRegister(Duration duration){
    _timeToRegister = duration;
    notifyListeners();
  }

  Duration getTimeToUpdate(){
    return _timeToUpdate;
  }

  setTimeToUpdate(Duration duration){
    _timeToUpdate = duration;
    notifyListeners();
  }

  List<ScheduleViewModel?> getScheduleList() {
    return _scheduleList;
  }

  setSelectedDay(Day newDay){
    selectedDay = newDay;
    notifyListeners();
  }

  deleteSchedule(ScheduleViewModel selectedCat){

    notifyListeners();
  }

  List<ScheduleMeal> getScheduleListByDay() {

    ScheduleViewModel? _scheduleListAux = _scheduleList[selectedDay.id!];

    if(_scheduleListAux != null){
      return _scheduleListAux.scheduleMealList;
    }
    else{
      return [];
    }

  }

  Future<void> populateScheduleList(BuildContext context) async {

    String id = Provider.of<CatListViewModel>(context, listen: false).getCats()[0].catId.toString();

    List<Schedule> auxScheduleList = await _scheduleService.getScheduleByUser(id);


    for(var schedule in auxScheduleList) {

      List<ScheduleMeal> auxScheduleMealList = await _scheduleService.getScheduleMeal(schedule.scheduleId.toString());

      if(auxScheduleMealList.isNotEmpty) {
        _scheduleList[schedule.day!.weekday] = ScheduleViewModel(schedule: schedule, scheduleMealList: auxScheduleMealList);
      }

    }

    notifyListeners();
  }


  Future<void> updateScheduleMeal(int index) async{

    _selectedScheduleMealDto.hour = _timeToUpdate.toString();

    _selectedScheduleMealDto.hour = _selectedScheduleMealDto.hour!.substring(0, _selectedScheduleMealDto.hour!.length - 4);

    await _scheduleService.updateMeal(_selectedScheduleMealDto).whenComplete((){
      updateLocalScheduleList(index);
    });
  }

  updateLocalScheduleList(int index) {
    _scheduleList[selectedDay.id!]!.scheduleMealList[index] = _selectedScheduleMealDto;
    notifyListeners();
  }

  updateDryFood(){
    _selectedScheduleMealDto.isDry = !_selectedScheduleMealDto.isDry!;
    notifyListeners();
  }

  updateDampFood(){
    _selectedScheduleMealDto.isDamp = !_selectedScheduleMealDto.isDamp!;
    notifyListeners();
  }

  updateMedicine(){
    _selectedScheduleMealDto.hasMedicine = !_selectedScheduleMealDto.hasMedicine!;
    notifyListeners();
  }


  Future<bool> registerSchedule(BuildContext context) async{

    _scheduleMealToRegister.hour = _timeToRegister.toString();

    _scheduleMealToRegister.hour = _scheduleMealToRegister.hour!.substring(0, _scheduleMealToRegister.hour!.length - 4);

    int catId = Provider.of<CatListViewModel>(context, listen: false).getCats()[0].catId!;

    await _scheduleService.registerSchedule(catId, selectedDay.date!).then((scheduleId) async {
      await _scheduleService.registerMeal(scheduleId, _scheduleMealToRegister).then((value){
        addScheduleRegistered(scheduleId, catId);
        return value;
      });
    });
    return false;
  }

  addScheduleRegistered(int scheduleId, int catId){

    List<ScheduleMeal> auxList = getScheduleListByDay();


    if(auxList.isNotEmpty){
      _scheduleList[selectedDay.id!]!.scheduleMealList.add(_scheduleMealToRegister);
    }
    else{
      _scheduleList.add(ScheduleViewModel(schedule: Schedule.fromSchedule(scheduleId, catId, true, selectedDay.date, ''), scheduleMealList: [_scheduleMealToRegister]));
    }

    notifyListeners();
  }

}