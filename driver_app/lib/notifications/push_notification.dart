
import 'package:driver_app/global/global.dart';
import 'package:driver_app/models/user_ride_request_info.dart';
import 'package:driver_app/notifications/notification_box.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotification{

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeFirebaseMessaging(BuildContext context) async {

    // ForeGround
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      //display user info who request a ride
      readUserRideInfo(message!.data["rideRequestId"], context);


    });

    //BackGround
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      //display user info who request a ride
      readUserRideInfo(message!.data["rideRequestId"], context);



    });

    //Terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message){
      if(message != null){
         //display user info who request a ride
        readUserRideInfo(message.data["rideRequestId"], context);


      }
    });


  }
  readUserRideInfo(String userRideRequestId, BuildContext context) {
    if (userRideRequestId == null) {
      Fluttertoast.showToast(msg: "Invalid ride Request.");
    }

    try{
    FirebaseDatabase.instance.ref().child("All Ride Requests")
        .child(userRideRequestId).once().then((value) {
      if(value.snapshot.value != null){

        double currentLat = double.parse((value.snapshot.value! as Map)["current"]["latitude"]);

        double currentLng = double.parse((value.snapshot.value! as Map)["current"]["longitude"]);
        String currentAddress = (value.snapshot.value! as Map)["currentAddress"];

        double destinationLat = double.parse((value.snapshot.value! as Map)["destination"]["latitude"]);

        double destinationLng = double.parse((value.snapshot.value! as Map)["destination"]["longitude"]);

        String destinationAddress = (value.snapshot.value! as Map)["destinationAddress"];

        String? rideRequestId = value.snapshot.key;

        String userName = (value.snapshot.value! as Map)["username"];
        String userPhoneNumber = (value.snapshot.value! as Map)["userPhoneNumber"];
        //instance

        UserRideRequestInfo userRideRequestInfo = UserRideRequestInfo(

            userName: userName,

            userPhoneNumber : userPhoneNumber,
            currentLatLng : LatLng(currentLat, currentLng),

            destinationLatLng : LatLng(destinationLat, destinationLng),

            currentAddress : currentAddress,

            destinationAddress: destinationAddress,

            rideRequestId: rideRequestId,
        );



        showDialog(context: context,
          builder: (BuildContext context) =>
            NotificationBox(
              userRideRequestInfo: userRideRequestInfo,
            ),
        );
      } else {
        Fluttertoast.showToast(msg: "The ride does not exists");
      }
    });

  }catch(e){
    print("Error reading ride Info: $e");
    Fluttertoast.showToast(msg: "Error Processing ride Request");
  }
    
  }

  Future generateTokenForDriver() async{
    try {
      String? generationToken = await messaging.getToken();

      if (generationToken != null) {
        await  FirebaseDatabase.instance
            .ref().child("drivers")
            .child(currentUser!.uid)

            .child("token").set(generationToken);

        messaging.subscribeToTopic("allDrives");
        messaging.subscribeToTopic("allUsers");

      } else {
        Fluttertoast.showToast(msg: "Error generating token");
      }
    } catch(e){

      print("Error generating token: $e");
      Fluttertoast.showToast(msg: "Error generating token");
    }
    }
  }
