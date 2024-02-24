import 'dart:convert';

import 'package:driver_app/models/total_trip_history.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../global/global.dart';
import '../info_handler/app_information.dart';
import '../models/direction_details.dart';
import '../models/directions.dart';
import '../models/user_model.dart';

class Assistant {

  //convert latitude and longitude to human readable Address
  static Future<String> searchAddress(Position position, context) async {
    String address = "";

    String googleApiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position
        .latitude},${position
        .longitude}&location_type=ROOFTOP&result_type=street_address&key=$mapKey";


    var request = await RequestAssistant.receivedRequest(googleApiUrl);

    if (request != "Failed, try again...") {
      // from google side
      address = request["results"][0]["formatted_address"];

      Direction userPickUpLocation = Direction(

          locationName : address,

          locationLatitude : position.latitude,

         locationLongitude : position.longitude,
      );


      Provider.of<AppInformation>(context, listen: false)
          .updateUserPickUpLocation(userPickUpLocation);
    }
    return address;
  }

  static Future<DirectionDetails?> getDirectionDetailsCurrentToDestination(
      LatLng pickUpPosition, LatLng dropOffPosition) async {
    String urlGetDirectionDetailsCurrentToDestination = "https://maps.googleapis.com/maps/api/directions/json?origin=${pickUpPosition
        .latitude},${pickUpPosition.longitude}&destination=${dropOffPosition
        .latitude},${dropOffPosition.longitude}&key=$mapKey";

    var responseApi = await RequestAssistant.receivedRequest(
        urlGetDirectionDetailsCurrentToDestination);

    if (responseApi == "Failed, try again...") {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails(
        points: responseApi["routes"][0]["overview_polyline"]["points"],

        distance_text : responseApi["routes"][0]["legs"][0]["distance"]["text"],

        distance_value : responseApi["routes"][0]["legs"][0]["distance"]["value"],

        duration_text : responseApi["routes"][0]["legs"][0]["duration"]["text"],

        duration_value : responseApi["routes"][0]["legs"][0]["duration"]["value"],
    );
    // From Google APIs


    return directionDetails;
  }

  static pauseLocationUpdates() {
    streamSubscriptionLocation!.pause();

    Geofire.removeLocation(currentUser!.uid);
  }

  static resumeLocationUpdates() {
    streamSubscriptionLocation!.resume();

    Geofire.setLocation(currentUser!.uid, userCurrentPosition!.latitude,
        userCurrentPosition!.longitude);
  }

  static void driverTotalEarnings(context) {
    FirebaseDatabase.instance
        .ref().child("drivers")
        .child(firebaseAuthentication.currentUser!.uid)
        .child("Earnings").once().then((value) {
      if (value.snapshot.value != null) {
        String totalEarnings = value.snapshot.value.toString();

        Provider.of<AppInformation>(context, listen: false).updateTotalEarnings(
            totalEarnings);
      }
    });
    readDriverTripId(context);
  }


  static void getTripInfo(context) {
    var tripIds = Provider
        .of<AppInformation>(context, listen: false)
        .tripIdsListHistory;

    //TotalTripHistory totalTripHistory = TotalTripHistory();
    for (int i = 0; i < tripIds.length; i++) {
      String getEachId = tripIds[i];
      FirebaseDatabase.instance
          .ref().child("All Ride Requests")
          .child(getEachId).once()
          .then((value) {
        var eachTripHistory = TotalTripHistory.fromSnapshot(value.snapshot);
        if ((value.snapshot.value as Map)["rideRequestStatus"] ==
            "trip Completed") {
          Provider.of<AppInformation>(context, listen: false)
              .updateTotalTripsHistory(eachTripHistory);
        }
      });
    }
  }




   // calculate amount for each vehicles
  static double calculateAmountFromCurrentToDestination(DirectionDetails directionDetails){
    // adjust the amount as local bus transport
    double timeTravelAmountPerMinute = (directionDetails.duration_value! / 60)*2;

    double distanceTravelAmountPerKm = (directionDetails.distance_value! / 1000) *2;

    double totalAmount = timeTravelAmountPerMinute + distanceTravelAmountPerKm;

    if(carType == "var"){
      double fireAmount = (totalAmount.truncate() * 2.0 );
      return fireAmount;
    }
    else if(carType == "car"){

      double fireAmount = (totalAmount.truncate().toDouble() );

      return fireAmount;
    }
    else if(carType == "bike"){

      double fireAmount = (totalAmount.truncate() / 2.0 );

      return fireAmount;
    }
    else{
      return totalAmount.truncate().toDouble();
    }


  }


  static void readDriverTripId(context){
    FirebaseDatabase.instance
        .ref().child("All Ride Requests")
        .orderByChild("driverId").equalTo(firebaseAuthentication.currentUser!.uid).once().then((value){
      if(value.snapshot.value != null){
        Map tripIds = value.snapshot.value as Map;

        //get total number of trips and share it with the help of Provider for the later usage
        int tripIdsCount = tripIds.length;

        Provider.of<AppInformation>(context, listen: false).updateTripIdsCount(tripIdsCount);

        List<String> tripIdsList = [];

        tripIds.forEach((key, value) {
          tripIdsList.add(key);
        });
        Provider.of<AppInformation>(context, listen: false).updateTotalTripIds(tripIdsList);
        getTripInfo(context);
      }
    });
  }


}

//Reverse GeoCoding APIs
class RequestAssistant{
  static Future<dynamic> receivedRequest(String url) async{
    http.Response response =  await http.get(Uri.parse(url));

    try{

      if(response.statusCode == 200){
        // json
        String responseData = response.body;

        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;

      } else{
        return "Failed, try again...";
      }
    } catch(exp){
      return "Failed, try again...";
    }


  }
}
