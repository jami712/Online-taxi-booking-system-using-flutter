
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/info_handler/app_information.dart';
import 'package:users_app/models/direction_details.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/online_nearest_drivers.dart';
import 'package:users_app/models/total_trip_history.dart';
import 'package:users_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class Assistant{

  //convert latitude and longitude to human readable Address
  static Future<String> searchAddress(Position position, context) async{

    String address="";

   // String googleApiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&location_type=ROOFTOP&result_type=street_address&key=$mapKey";
      String googleApiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";


   var request = await RequestAssistant.receivedRequest(googleApiUrl);

   if(request != "Failed, try again..."){
     // from google side

     address =  request["results"][0]["formatted_address"];

     Directions userPickUpLocation = Directions();
   userPickUpLocation.locationName = address;

   userPickUpLocation.locationLatitude = position.latitude;

   userPickUpLocation.locationLongitude = position.longitude;

   Provider.of<AppInformation>(context, listen: false).updateUserPickUpLocation(userPickUpLocation);
   }
   return address;
  }
  static void readCurrentOnLineUsersInfo() async{
    currentFirebaseUser = firebaseAuthentication.currentUser;

    DatabaseReference reference = FirebaseDatabase.instance.ref().child("users").child(currentFirebaseUser!.uid);
    reference.once().then((snap){

      if(snap.snapshot.value != null){
       userModelCurrentInformation =  UserModel.fromSnapshot(snap.snapshot);

      }
    });
  }
  static Future<DirectionDetails?> getDirectionDetailsCurrentToDestination(LatLng pickUpPosition, LatLng dropOffPosition) async {
    String urlGetDirectionDetailsCurrentToDestination = "https://maps.googleapis.com/maps/api/directions/json?origin=${pickUpPosition.latitude},${pickUpPosition.longitude}&destination=${dropOffPosition.latitude},${dropOffPosition.longitude}&key=$mapKey";
    
   var responseApi = await RequestAssistant.receivedRequest(urlGetDirectionDetailsCurrentToDestination);
   if(responseApi == "Failed, try again..."){
     return null;
   }
   DirectionDetails directionDetails = DirectionDetails();

    directionDetails.e_points = responseApi["routes"][0]["overview_polyline"]["points"];
    directionDetails.distance_text = responseApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distance_value = responseApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.duration_text = responseApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.duration_value = responseApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
  //Amount
  static double calculateAmountFromCurrentToDestination(DirectionDetails directionDetails){
    // adjust the amount as local bus transport
    double timeTravelAmountPerMinute = (directionDetails.duration_value! / 60)*2;
    double distanceTravelAmountPerKm = (directionDetails.distance_value! /1000) *2;
    double totalAmount = timeTravelAmountPerMinute + distanceTravelAmountPerKm;
    
    return double.parse(totalAmount.toStringAsFixed(2));

  }

  static sendingNotificationToSelectedDriver(String driverToken, String userRideRequestId, context) async{

    var userDestinationAddress = userDestination;

    Map<String, String> notificationHeader = {

      'Content-Type': 'application/json',
      'Authorization': messagingServerToken,
    };
    Map notificationBody = {
      'body': 'you received a ride to \n$userDestinationAddress',
      'title': 'Online Taxi Booking System'
    };
    Map mapData = {
      'click_action':'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'rideRequestId': userRideRequestId
    };
    Map officialNotificationFormat = {
      'notification': notificationBody,
      'priority': 'high',
      'data': mapData,
      'to': driverToken
     };
    var responseNotification = http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: notificationHeader,
      body: jsonEncode(officialNotificationFormat),
    );

  }

  static void readUserTripId(context){
    FirebaseDatabase.instance
        .ref().child("All Ride Requests")
        .orderByChild("username").equalTo(userModelCurrentInformation!.name).once().then((value){
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

 static void getTripInfo(context){

   var tripIds = Provider.of<AppInformation>(context, listen: false).tripIdsListHistory;

   //TotalTripHistory totalTripHistory = TotalTripHistory();
   for(String getEachId in tripIds){
     FirebaseDatabase.instance
         .ref().child("All Ride Requests")
         .child(getEachId).once()
         .then((value){
           var eachTripHistory = TotalTripHistory.fromSnapshot(value.snapshot);
          if((value.snapshot.value as Map )["rideRequestStatus"] == "trip Completed"){

            Provider.of<AppInformation>(context, listen: false).updateTotalTripsHistory(eachTripHistory);
          }


     });
   }
  }

}

class RequestAssistant{
  static Future<dynamic> receivedRequest(String url) async{
    http.Response httpResponse =  await http.get(Uri.parse(url));

    try{

      if(httpResponse.statusCode == 200){ //successful response
        // json
        String responseData = httpResponse.body;

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

//GroFire Assistant
class GeoFireAssistant{

  static List<OnlineNearestDrivers> onlineNearestDriversList = [];
  static void removeOfflineDriverFromList(String driverId){

    int indexNumber = onlineNearestDriversList.indexWhere((element) => element.driverId == driverId);

    onlineNearestDriversList.removeAt(indexNumber);


  }
  static void updateOnlineNearestDriversList(OnlineNearestDrivers driverMove){
    int indexNumber = onlineNearestDriversList.indexWhere((element) => element.driverId == driverMove.driverId);
    onlineNearestDriversList[indexNumber].locationLatitude = driverMove.locationLatitude;
    onlineNearestDriversList[indexNumber].locationLongitude = driverMove.locationLongitude;


  }
}