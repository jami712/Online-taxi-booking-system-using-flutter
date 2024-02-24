import 'package:flutter/cupertino.dart';
import 'package:users_app/models/total_trip_history.dart';

import '../models/directions.dart';

class AppInformation extends ChangeNotifier{

  Directions? userPickUpLocation;

  Directions? userDropOffLocation;
  int totalTripIdsCount = 0;

  List<String> tripIdsListHistory = [];

  List<TotalTripHistory> totalTripHistoryList = [];


  void updateUserPickUpLocation(Directions pickUpLocation){
     userPickUpLocation = pickUpLocation;
     notifyListeners();
}

  void updateUserDrpOffLocation(Directions dropOffLocation){
    userDropOffLocation = dropOffLocation;
    notifyListeners();
  }
  updateTripIdsCount(int tripIdsCount){
    totalTripIdsCount = tripIdsCount;
    notifyListeners();
  }
  updateTotalTripIds(List<String> tripIdsList){

    tripIdsListHistory = tripIdsList;
    notifyListeners();
  }
  updateTotalTripsHistory(TotalTripHistory eachTripHistory){

    totalTripHistoryList.add(eachTripHistory);
    notifyListeners();
  }

}