import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInfo{
  String? userName;
  String? userPhoneNumber;
  String? rideRequestId;

  String? currentAddress;
  String? destinationAddress;
  LatLng? currentLatLng;
  LatLng? destinationLatLng;


  UserRideRequestInfo({
    this.userName,
    this.userPhoneNumber,

    this.destinationLatLng,
    this.currentLatLng,
    this.currentAddress,

    this.destinationAddress,
    this.rideRequestId,
});
}