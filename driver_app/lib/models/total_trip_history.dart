
import 'package:firebase_database/firebase_database.dart';

class TotalTripHistory{

  String? currentAddress;
  String? destinationAddress;
  String? time;
  String? totalTripAmount;
  String? rideRequestStatus;

  TotalTripHistory({
    this.rideRequestStatus,
    this.totalTripAmount,
    this.destinationAddress,
    this.currentAddress,
    this.time,

});
  TotalTripHistory.fromSnapshot(DataSnapshot dataSnapshot){

    currentAddress =  (dataSnapshot.value as Map )["currentAddress"];

    destinationAddress =  (dataSnapshot.value as Map )["destinationAddress"];

    totalTripAmount =  (dataSnapshot.value as Map )["totalTripAmount"];

    rideRequestStatus =  (dataSnapshot.value as Map )["rideRequestStatus"];
    time =  (dataSnapshot.value as Map )["time"];

  }

}