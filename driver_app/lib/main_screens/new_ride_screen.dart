import 'dart:async';

import 'package:driver_app/assistant/assistant_methods.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/main_screens/progress_dialog.dart';
import 'package:driver_app/main_screens/rate_user.dart';
import 'package:driver_app/main_screens/total_amount_dialog.dart';
//import 'package:driver_app/info_handler/app_information.dart';
import 'package:driver_app/models/user_ride_request_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:provider/provider.dart';

class NewRideScreen extends StatefulWidget {


  UserRideRequestInfo? userRideRequestInfo;

  NewRideScreen({super.key, this.userRideRequestInfo,
});

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {

  GoogleMapController? newRideGoogleMapController;

  final Completer<GoogleMapController> _controllerGoogleMap =

  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(

    target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746,
  );

  customMapTheme() {
    //black theme
    newRideGoogleMapController!.setMapStyle('''
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

  Position? onlineDriverPosition;

  String rideStatus = "Accepted";

  String timeDuration = "";
  double bottomMapPadding = 0;
  double topMapPadding = 0;

  bool isRequestDirection = false;

  String? buttonTitle = "Arrived";

  Color? buttonColor = Colors.lightBlue;

  Set<Circle> circles = <Circle>{};

  Set<Marker> markers = <Marker>{};
  Set<Polyline> setOfPolyLine = <Polyline>{};

  List<LatLng> polyLineList = [];

  PolylinePoints polylinePoints = PolylinePoints();

  BitmapDescriptor? animatedMarker;

  var geoLocator = Geolocator();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveDriverInfoToUserRideRequest();
  }


  void changerMapType(){
    setState(() {
      currentMapType = currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });


  }

  @override
  Widget build(BuildContext context) {
    driverIconMarker();

    return Scaffold(
      body: Stack(

        children: [
          GoogleMap(

            padding: EdgeInsets.only(bottom: bottomMapPadding,
                top:topMapPadding),

            mapType: currentMapType,
            myLocationEnabled: true,

            markers: markers,
            circles: circles,
            polylines: setOfPolyLine,

            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newRideGoogleMapController = controller;

              setState(() {
                bottomMapPadding = 340;
                topMapPadding = 30;

              });

              //for black theme
              customMapTheme();

              var driverCurrentLatLng = LatLng(userCurrentPosition!.latitude,
                  userCurrentPosition!.longitude);

              var userPickUpLatLng = widget.userRideRequestInfo!.currentLatLng;

              drawPolyLineFromCurrentToDestination(
                  driverCurrentLatLng, userPickUpLatLng!);

              getAndUpdateDriverLocationInRealTime();
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

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,

            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),

                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white54,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.6, 0.6),

                    ),
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    Text(
                      timeDuration,
                      style: const TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18,),

                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10,),

                    Row(
                      children: [
                        Text(
                          widget.userRideRequestInfo!.userName!,
                          style: const TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            onPressed: () {
                              makeCallToDriver(userPhoneNumber);
                            },
                            icon: const Icon(Icons.phone_android),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18,),

                    //user pickup location
                    Row(
                      children: [
                        const Text(
                          "From: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20,),

                        Expanded(
                          child: Container(
                            child: Text(
                              widget.userRideRequestInfo!.currentAddress!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),


                    Row(
                      children: [
                        const Text(
                          "To: ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Container(
                            child: Text(
                              widget.userRideRequestInfo!.destinationAddress!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10,),

                    ElevatedButton.icon(
                      onPressed: () async {
                        buttonAction();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                      ),
                      icon: const Icon(
                        Icons.directions_car,
                        color: Colors.white54,
                        size: 23,
                      ),
                      label: Text(
                        buttonTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,

                        ),
                      ),

                    ),
                    //user dropOff location
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  driverIconMarker() {
    if (animatedMarker == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
          context, size: const Size(1, 1));

      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/carr.png")
          .then((value) {
        animatedMarker = value;
      });
    }
  }

  getAndUpdateDriverLocationInRealTime() {
    LatLng previousLatLng = const LatLng(0, 0);

    //streamSubscription update live location at real time in every second
    streamSubscriptionLiveLocation = Geolocator.getPositionStream()

        .listen((Position position) async {
     // userCurrentPosition = position;

      onlineDriverPosition = position;

      LatLng latLngLiveLocation = LatLng(
          onlineDriverPosition!.latitude, onlineDriverPosition!.longitude);

      List<Placemark> placeMark = await placemarkFromCoordinates(
        onlineDriverPosition!.latitude,
        onlineDriverPosition!.longitude,

      );
      String humanReadableAddress = placeMark.isNotEmpty
          ?'${placeMark[0].name},${placeMark[0].locality},${placeMark[0].subLocality}, ${placeMark[0].administrativeArea}'
          : 'Unknown Address';

      Marker iconMarker = Marker(

        markerId: const MarkerId("Marker"),

        position: latLngLiveLocation,
        icon: animatedMarker!,

        infoWindow:  InfoWindow(title:humanReadableAddress , snippet: "Current Location"),

      );
      setState(() {
        CameraPosition cameraPosition = CameraPosition(
            target: latLngLiveLocation, zoom: 13);

        newRideGoogleMapController!
            .animateCamera(CameraUpdate
            .newCameraPosition(cameraPosition));

        //remove previous icons
        markers.removeWhere((element) => element.markerId.value == "Marker");


        markers.add(iconMarker);
      });
      previousLatLng = latLngLiveLocation;

      updateTimeDuration();

      Map<String, String> driverLatLng = {
        "latitude": onlineDriverPosition!.latitude.toString(),

        "longitude": onlineDriverPosition!.longitude.toString(),
      };
      //updating Driver Location in database
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Requests")
          .child(widget.userRideRequestInfo!.rideRequestId!)
          .child("driverLocation").set(driverLatLng);
    });
  }

  updateTimeDuration() async {
    if (isRequestDirection == false) {
      isRequestDirection = true;

      LatLng? destinationLatLng;

      if (onlineDriverPosition == null) {
        Fluttertoast.showToast(msg: "Could not get your Location.");
        return;
      }
      var currentLatLng = LatLng(
          onlineDriverPosition!.latitude, onlineDriverPosition!.longitude);
      if (rideStatus == "Accepted") {
        destinationLatLng = widget.userRideRequestInfo!.currentLatLng;
      } else {
        destinationLatLng = widget.userRideRequestInfo!.destinationLatLng;
      }
      var directionInfo = await Assistant
          .getDirectionDetailsCurrentToDestination(
          currentLatLng, destinationLatLng!);

      if (directionInfo != null) {
        setState(() {
          timeDuration = directionInfo.duration_text!;
        });
      }
      isRequestDirection = false;
    }
  }

  Future<void> drawPolyLineFromCurrentToDestination(LatLng currentLatLng,
      LatLng destinationLatLng) async {
    try {
      showDialog(
        context: context,

        builder: (BuildContext context) =>

            ProgressDialog(message: "Please Wait...",),
      );
      var directionInfo = await Assistant
          .getDirectionDetailsCurrentToDestination(
          currentLatLng, destinationLatLng);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      PolylinePoints point = PolylinePoints();

      List<PointLatLng> decodedPointResult = point.decodePolyline(
          directionInfo!.points!);

      polyLineList.clear();

      if (decodedPointResult.isNotEmpty) {
        decodedPointResult.forEach((PointLatLng pointLatLng) {
          polyLineList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        });
      }


      setOfPolyLine.clear();

      setState(() {
        Polyline polyLine = Polyline(

          polylineId: const PolylineId("PolylineId"),
          jointType: JointType.bevel,

          points: polyLineList,

          startCap: Cap.roundCap,

          endCap: Cap.squareCap,
          geodesic: true,
          color: Colors.blue,
          width: 5,

        );
        setOfPolyLine.add(polyLine);
      });
      //zoom out animation
      LatLngBounds boundLatLng;

      if (currentLatLng.latitude > destinationLatLng.latitude
          && currentLatLng.longitude > destinationLatLng.longitude) {
        boundLatLng = LatLngBounds(
            southwest: destinationLatLng, northeast: currentLatLng);
      } else if (currentLatLng.longitude > destinationLatLng.longitude) {
        boundLatLng = LatLngBounds(

          southwest: LatLng(currentLatLng.latitude,
              destinationLatLng.longitude),

          northeast: LatLng(destinationLatLng.latitude,
              currentLatLng.longitude),
        );
      } else if (currentLatLng.latitude > destinationLatLng.latitude) {
        boundLatLng = LatLngBounds(

          southwest: LatLng(destinationLatLng.latitude,
              currentLatLng.longitude),
          northeast: LatLng(currentLatLng.latitude,
              destinationLatLng.longitude),

        );
      } else {
        boundLatLng = LatLngBounds(southwest: currentLatLng,
            northeast: destinationLatLng);
      }
      newRideGoogleMapController!.animateCamera(
          CameraUpdate.newLatLngBounds(boundLatLng, 60));

      List<Placemark> placeMark = await placemarkFromCoordinates(
        currentLatLng.latitude,
        currentLatLng.longitude,

      );
      String currentAddress = placeMark.isNotEmpty
          ?'${placeMark[0].name},${placeMark[0].locality},${placeMark[0].subLocality}, ${placeMark[0].administrativeArea}'
          : 'Unknown Address';

      Marker currentLocationMarker = Marker(

        markerId: const MarkerId("CurrentLocationID"),
        infoWindow: InfoWindow(title: currentAddress, snippet: "Current Location"),

        position: currentLatLng,

        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      List<Placemark> placeMarks = await placemarkFromCoordinates(
        destinationLatLng.latitude,
        destinationLatLng.longitude,

      );
      String destinationAddress = placeMarks.isNotEmpty
          ?'${placeMarks[0].name},${placeMarks[0].locality},${placeMarks[0].subLocality}, ${placeMarks[0].administrativeArea}'
          : 'Unknown Address';

      Marker destinationMarker = Marker(

        markerId: const MarkerId("DestinationLocationID"),
        infoWindow:  InfoWindow(title: destinationAddress, snippet: "Destination"),
        position: destinationLatLng,

        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );


      Circle currentLocationCircle = Circle(
        circleId: const CircleId("CurrentLocationID"),
        fillColor: Colors.cyan,
        strokeColor: Colors.white,
        radius: 12,
        strokeWidth: 3,
        center: currentLatLng,
      );
      Circle destinationLocationCircle = Circle(
        circleId: const CircleId("DestinationLocationID"),
        fillColor: Colors.green,
        strokeColor: Colors.white,
        radius: 12,
        strokeWidth: 3,
        center: destinationLatLng,
      );

      setState(() {
        markers.add(currentLocationMarker);
        markers.add(destinationMarker);
      });

      setState(() {
        circles.add(currentLocationCircle);
        circles.add(destinationLocationCircle);
      });
    } catch (e) {
      print("Error: $e");
      Navigator.pop(context);
    }
  }


  saveDriverInfoToUserRideRequest() {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref().child("All Ride Requests")
        .child(widget.userRideRequestInfo!.rideRequestId!);

    Map<String, dynamic> driverLocation = {

      "latitude": userCurrentPosition!.latitude.toString(),
      "longitude": userCurrentPosition!.longitude.toString(),
    };
    Map<String, dynamic> carDetails = {
      "car_number": driversData.car_number.toString(),
      "car_model": driversData.car_model.toString(),
      "car_type": carType,
    };
    Map<String, dynamic> driverInfo = {
      "driverId": driversData.id,
      "driverName": driversData.name,
      "driverPhone": driversData.phone,
      "car_details": carDetails,
    };

    ref.update({
      "driverLocation": driverLocation,
      "rideRequestStatus": rideStatus,
      ...driverInfo,
    });

    ref.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        return;
      }
      if ((event.snapshot.value as Map)["userPhoneNumber"] != null) {
        setState(() {
          userPhoneNumber =
              (event.snapshot.value as Map)["userPhoneNumber"].toString();
        });
      }
    });


    // saveRideRequestIdToDriverHistory();

  }


  saveTotalEarnedAmount(double totalTripAmount)  {
    try {
      var earningsRef = FirebaseDatabase.instance.ref().child("drivers").child(
          currentUser!.uid).child("Earnings");

      // Get current earnings value
      earningsRef.once().then((value) {
        if (value.snapshot.value != null) {
          double oldTotalEarnings = double.parse(
              value.snapshot.value.toString());
          double newTotalEarnings = oldTotalEarnings + totalTripAmount;

          // Save new total earnings
           earningsRef.set(newTotalEarnings.toString());
        } else {
          // If no previous earnings, create a new entry
          earningsRef.set(totalTripAmount.toString());
        }

        // Save earnings history
         saveEarningsHistory(totalTripAmount);

        saveRideRequestIdToDriverHistory();

      });

    } catch (error) {
      print("Error saving total earnings: $error");
      // Handle errors as needed
    }
  }

  Future<void> saveEarningsHistory(double tripAmount) async {
    try {
      var historyRef = FirebaseDatabase.instance.ref().child("drivers").child(
          currentUser!.uid).child("EarningsHistory");

      var timestamp = DateTime
          .now()
          .toUtc()
          .second;

      // Save earnings history
      await historyRef.child(timestamp.toString()).set({
        "amount": tripAmount.toString(),
        "timeStampInSec": timestamp,
      });
    } catch (error) {
      print("Error saving earnings history: $error");
      // Handle errors as needed
    }
  }


  Future<void> makeCallToDriver(String phoneNumber) async {
    final Uri makeCall = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunch(makeCall.toString())) {
      await launch(makeCall.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void buttonAction() async {
    //driver ready to pick the user
    if (rideStatus == "Accepted") {
      rideStatus = "arrived";
      FirebaseDatabase.instance
          .ref().child("All Ride Requests")
          .child(widget.userRideRequestInfo!.rideRequestId!)
          .child("rideRequestStatus").set(rideStatus);
      setState(() {
        buttonTitle = "Start Trip";
        buttonColor = Colors.green;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Please Wait..."),
      );

      await drawPolyLineFromCurrentToDestination(
          widget.userRideRequestInfo!.currentLatLng!,
          widget.userRideRequestInfo!.destinationLatLng!);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
    //ready to start the trip

    else if (rideStatus == "arrived") {
      rideStatus = "onTrip";
      FirebaseDatabase.instance
          .ref().child("All Ride Requests")
          .child(widget.userRideRequestInfo!.rideRequestId!)
          .child("rideRequestStatus").set(rideStatus);
      setState(() {
        buttonTitle = "End Trip";
        buttonColor = Colors.deepOrangeAccent;
      });
    }
    else if (rideStatus == "onTrip") {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            ProgressDialog(message: "Please Wait...",),
      );
      var currentDriverLatLng = LatLng(
          onlineDriverPosition!.latitude, onlineDriverPosition!.longitude);

      var tripDetails = await Assistant.getDirectionDetailsCurrentToDestination(
          currentDriverLatLng, widget.userRideRequestInfo!.currentLatLng!);

      double totalTripAmount = Assistant
          .calculateAmountFromCurrentToDestination(tripDetails!);

      FirebaseDatabase.instance
          .ref().child("All Ride Requests")
          .child(widget.userRideRequestInfo!.rideRequestId!)
          .child("totalTripAmount").set(totalTripAmount.toString());

      FirebaseDatabase.instance
          .ref().child("All Ride Requests")
          .child(widget.userRideRequestInfo!.rideRequestId!)
          .child("rideRequestStatus").set("trip Completed");


      streamSubscriptionLiveLocation!.cancel();

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // ignore: use_build_context_synchronously
      var response = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c) =>
              TotalAmountDialog(totalTripAmount: totalTripAmount));
      if(response == "AmountCollected") {
        FirebaseDatabase.instance
            .ref().child("All Ride Requests")
            .child(widget.userRideRequestInfo!.rideRequestId!)
            .once().then((value){

          if ((value.snapshot.value as Map)["UserId"] != null) {

            String userId = (value.snapshot.value as Map)["UserId"]
                .toString();

            // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(

                builder: (c) => RateTheUser(userId: userId)));

          }
        });

        //rate the user

      }

      saveTotalEarnedAmount(totalTripAmount);
    }
  }

  void saveRideRequestIdToDriverHistory(){
    DatabaseReference tripHistoryRef = FirebaseDatabase.instance
        .ref().child("drivers")
        .child(currentUser!.uid)
        .child("tripHistory");

    tripHistoryRef.child(widget.userRideRequestInfo!.rideRequestId!).set(true);
  }
}

