import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driver_app/assistant/assistant_methods.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/models/user_ride_request_info.dart';
import 'package:driver_app/notifications/push_notification.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}


class _HomeTabPageState extends State<HomeTabPage> {



  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  var geolocator = Geolocator();

  LocationPermission? _locationPermission;
 double topMapPadding = 0;




  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionAllowed();
    readCurrentDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: topMapPadding),
          mapType: currentMapType,

          myLocationEnabled: true,

          initialCameraPosition: _kGooglePlex,

          onMapCreated: (GoogleMapController controller){
            _controllerGoogleMap.complete(controller);

            newGoogleMapController = controller;
            setState(() {

              topMapPadding = 30;

            });

            //for black theme
            blackThemeGoogleMap();
            // Update the driver's position on the map
            driverPosition();
          },
        ),
        Container(
          padding: const EdgeInsets.only(top: 90, right: 5),
          alignment: Alignment.topRight,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: changerMapType,
                backgroundColor: Colors.transparent,
                child: const Icon(Icons.map, size: 30,),
              ),

            ],
          ),
        ),

        //UI for offline and online driver
         statusText != "Online"
             ? Container(
           height: MediaQuery.of(context).size.height,
           width: double.infinity,
           color: Colors.black45,
         )
             : Container(),
        //Button for Online and Offline
        Positioned(

          left: 0,
          right: 0,
          top: statusText != "Online"

              ? MediaQuery.of(context).size.height * 0.40
              : 25,

          child: Row(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              ElevatedButton(

                  onPressed:(){
                    if(isActive != true ){

                      onlineDriver();
                      updateDriverLocation();

                      setState(() {
                        statusText = "Online";

                        statusColor = Colors.transparent;
                        isActive = true;

                      });

                      //Toast
                      Fluttertoast.showToast(msg: "You are Online.");
                    } else{
                      offlineDriver();
                      setState(() {

                        statusText = "Offline";

                        statusColor = Colors.white10;

                        isActive = false;

                      });
                      //Toast
                      Fluttertoast.showToast(msg: "You are Offline.");

                    }

                  },
                style: ElevatedButton.styleFrom(

                  backgroundColor: statusColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)

                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                ),
                  child: statusText != "Online"
                      ? Text(
                    statusText,
                    style: const TextStyle(

                      color: Colors.white54,
                      fontSize: 15.0,

                      fontWeight: FontWeight.bold,
                    ),
                  )
                :const Icon(

                    color: Colors.white54,

                    size: 15,
                    Icons.phonelink_ring,

                  ),
              ),
            ],
          ),
    ),

      ],
    );
  }

  blackThemeGoogleMap(){
    //black theme
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }



  void changerMapType(){
    setState(() {
      currentMapType = currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });

  }


 Future<void> readCurrentDriverInfo() async {
    try {
      currentUser = firebaseAuthentication.currentUser;

      FirebaseDatabase.instance.
      ref().child("drivers")
          .child(currentUser!.uid)
          .once().then((value) {
            print("Data from database: ${value.snapshot.value}");

            if (value.snapshot.value != null) {

          //Extract driver information from database
          driversData.id = (value.snapshot.value as Map)["id"];
          driversData.name = (value.snapshot.value as Map)["name"];
          driversData.email = (value.snapshot.value as Map)["email"];
          driversData.phone = (value.snapshot.value as Map)["phone"];
          driversData.car_model = (value.snapshot.value as Map)["car_details"]["car_model"];
          driversData.car_number = (value.snapshot.value as Map)["car_details"]["car_number"];
          carType = (value.snapshot.value as Map)["car_details"]["car_type"];
          driverName = (value.snapshot.value as Map)["name"];
          driverPhone = (value.snapshot.value as Map)["phone"];
          driverEmail =  (value.snapshot.value as Map)["email"];
          ratings = (value.snapshot.value as Map)["ratings"];


        }
      });
      PushNotification pushNotification = PushNotification();
      await pushNotification.initializeFirebaseMessaging(context);
      await pushNotification.generateTokenForDriver();

      // ignore: use_build_context_synchronously
      Assistant.driverTotalEarnings(context);
    } catch (e) {
      print("Error reading driver info : $e");
    }
  }

 Future<void> onlineDriver() async {

    try {
      // Get the current position of the driver
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      userCurrentPosition = pos;

      // Initialize Geofire with the key "onlineDrivers"
      Geofire.initialize("onlineDrivers");

      // Set the location of the current user (driver) using Geofire
      Geofire.setLocation(
          currentUser!.uid,

          userCurrentPosition!.latitude,
          userCurrentPosition!.longitude);

      DatabaseReference reference = FirebaseDatabase.instance.ref()
          .child("drivers").child(currentUser!.uid).child("newRide");

      reference.set("Ready for Ride");
      reference.onValue.listen((event) {});
    }catch(e){
      print("Error setting driver online: $e");
      Fluttertoast.showToast(msg: "Error while setting driver Online");
    }
  }

  Future<void> checkIfLocationPermissionAllowed()async {
    try {
      _locationPermission = await Geolocator.requestPermission();

      if (_locationPermission == LocationPermission.denied) {
        _locationPermission = await Geolocator.requestPermission();
      }
      if(_locationPermission == LocationPermission.deniedForever){
        // ignore: use_build_context_synchronously
        await showDialog(
            context: context,
            builder: (BuildContext context){
              return const AlertDialog(
                title: Text("Location Permission Required"),
                content: Text("Please enable location in device setting"),
              );

            });
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }catch(e){
      print("Error checking location permission");
    }

  }

 Future<void> driverPosition() async {
    try{


    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    userCurrentPosition = currentPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target:latLngPosition, zoom: 12);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));



    // ignore: use_build_context_synchronously
    await Assistant.searchAddress(userCurrentPosition!, context);



  }catch(e){
      print("Error updating driver position or  not getting ratings : $e");

    }
 }

 void updateDriverLocation(){
    try{


// Listen to the position stream for continuous updates
    streamSubscriptionLocation = Geolocator.getPositionStream()
        .listen((Position position) {

          userCurrentPosition = position;
// Check if the driver is active before updating the location
          if(isActive == true){

            Geofire.setLocation(
                currentUser!.uid,

                userCurrentPosition!.latitude,
                userCurrentPosition!.longitude);
          }

          LatLng latLng =  LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

          newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));


    });

  }catch(e){
    print("Error updating driver location");
    }
 }

 void offlineDriver() {
    try {
      // Remove the driver's location using Geofire
      Geofire.removeLocation(currentUser!.uid);

      // Remove the "newRide" status in the Realtime Database
      DatabaseReference? reference = FirebaseDatabase.instance.ref()
          .child("drivers").child(currentUser!.uid).child("newRide");

      reference.onDisconnect().remove();
      reference = null;
    }catch(e){
      print("Error setting driver offline: $e");

    }

    Future.delayed(const Duration(milliseconds: 2000),(){
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");

    });
  }

  }


