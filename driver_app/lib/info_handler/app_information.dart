import 'package:driver_app/models/total_trip_history.dart';
import 'package:flutter/cupertino.dart';


import '../models/directions.dart';

class AppInformation extends ChangeNotifier{

  Direction? userPickUpLocation;
  Direction? userDropOffLocation;

  List<String> tripIdsListHistory = [];
  List<TotalTripHistory> totalTripHistoryList = [];

  String driverTotalEarnings = "0";
  int totalTripIdsCount = 0;


  void updateUserPickUpLocation(Direction pickUpLocation){

     userPickUpLocation = pickUpLocation;

     notifyListeners();
}

  void updateUserDrpOffLocation(Direction dropOffLocation){

    userDropOffLocation = dropOffLocation;

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

  updateTripIdsCount(int tripIdsCount){

    totalTripIdsCount = tripIdsCount;

    notifyListeners();
  }


  updateTotalEarnings(String totalEarnings){

     driverTotalEarnings = totalEarnings;

     notifyListeners();

  }


}