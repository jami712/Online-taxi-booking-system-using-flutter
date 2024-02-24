
import 'package:driver_app/assistant/assistant_methods.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/main.dart';
import 'package:driver_app/main_screens/new_ride_screen.dart';

import 'package:driver_app/models/user_ride_request_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationBox extends StatefulWidget {




  NotificationBox({super.key, this.userRideRequestInfo});

  UserRideRequestInfo? userRideRequestInfo;

  @override
  State<NotificationBox> createState() => _NotificationBoxState();
}

class _NotificationBoxState extends State<NotificationBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(

      backgroundColor: Colors.black12,

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),

      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          color: Colors.white12,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10,),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/car1.png", width: 160,),
                  ],
                ),
                Positioned(
                  top: -8,
                  right: -5,
                  child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel, size: 30,),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6,),
            const Text(
              "New Ride Request",
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12,),
            const Divider(
              height: 2,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildInfoRow("From", widget.userRideRequestInfo!.currentAddress!),
                  const SizedBox(height: 22,),
                  buildInfoRow("To", widget.userRideRequestInfo!.destinationAddress!),
                ],
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: (){
                      cancelRide(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30,),
                  ElevatedButton(
                    onPressed: (){
                      acceptRide(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }

//Helper Functions

  buildInfoRow(String label, String value){

   return Row(
      children: [
         Text(
          "$label: ",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 20,),

        Expanded(
          child: Container(
            child: Text(
              value,
              style:const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  cancelRide(BuildContext context) {
    try{
    FirebaseDatabase.instance
        .ref().child("All Ride Requests")
        .child(widget.userRideRequestInfo!.rideRequestId!)
        .remove().then((value) {
      FirebaseDatabase.instance
          .ref().child("drivers")
          .child(currentUser!.uid)
          .child("newRide")
          .set("Ready for Ride");
    }).then((value) {
      Fluttertoast.showToast(msg: "You cancel the Ride.");
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      MyApp.restartApp(context);
      //Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
    });
  } catch(e){
    print("Error canceling ride: $e");
    Fluttertoast.showToast(msg: "Error canceling ride");
  }

  }

  acceptRide(BuildContext context) {
    try{
    String rideStatus = "";

    FirebaseDatabase.instance.ref()
        .child("drivers").child(currentUser!.uid)

        .child("newRide").once().then((value) {
      if (value.snapshot.value != null) {
        rideStatus = value.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: "This Ride has been deleted.");
        Navigator.pop(context);
      }

      if (rideStatus == widget.userRideRequestInfo!.rideRequestId) {
        FirebaseDatabase.instance.ref()
            .child("drivers").child(currentUser!.uid)
            .child("newRide").set("accepted");

        Assistant.pauseLocationUpdates();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) =>
                    NewRideScreen(
                        userRideRequestInfo: widget.userRideRequestInfo)));
      } else {
        Fluttertoast.showToast(msg: "This Ride has been deleted.");

      }
    });
  }catch(e){
    print("Error accepting ride: $e");
    Fluttertoast.showToast(msg: "Error accepting ride");
  }

  }
}
