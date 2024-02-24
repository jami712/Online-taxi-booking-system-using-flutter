import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
//import 'package:users_app/authentication/login.dart';
import 'package:users_app/info_handler/app_information.dart';
import 'package:users_app/main.dart';
import 'package:users_app/main_screens/location_info_row.dart';
import 'package:users_app/main_screens/my_drawer.dart';
import 'package:users_app/main_screens/progress_dialog.dart';
import 'package:users_app/main_screens/rate_driver.dart';
import 'package:users_app/main_screens/search_places.dart';
import 'package:users_app/main_screens/select_online_driver.dart';
import 'package:users_app/main_screens/total_amount_dialog.dart';

//import 'package:users_app/main.dart';
//import 'package:users_app/models/direction_details.dart';
import 'package:users_app/models/online_nearest_drivers.dart';


class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;


   var geolocator = Geolocator();

  LocationPermission? permissionStatus;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double newBottomPaddingMap = 0;
  double topMapPadding = 0;

  List<LatLng> polyLineList =  [];
  Set<Polyline> newPolyLineSet = {};

  Set<Marker> newMarkerSets = {};
  Set<Circle> newCircleSets ={};
  Set<Marker> driverMarker = <Marker>{};

  bool openNavigationDrawer = true;

  BitmapDescriptor? animatedMarker;
  Position? onlineDriverPosition;

  Position? userCurrentPosition;
  bool onlineDriverKeyLoaded = false;

  DatabaseReference? rideRequestReference;

 List<OnlineNearestDrivers> nearestOnlineDriverList = [];
 double showingLocationContainerHeight = 220;
 double waitingResponseContainerHeight = 0;

 double assignedDriverContainerHeight = 0;
 String driverStatus = "Driver is on the way...";

 StreamSubscription<DatabaseEvent>? rideStreamSubscription;
 String newRideStatus = " ";
 bool rideRequestPositionInfo = true;
  double? driverCurrentPositionLng;
  double? driverCurrentPositionLat;
  // ignore: prefer_typing_uninitialized_variables
  var driverCurrentLocationLatLng;
  OnlineNearestDrivers? onlineNearestDrivers;


  @override
  void initState() {
    super.initState();
    checkAndRequestLocationPermission();
    startStreaming();

  }



  @override
  Widget build(BuildContext context) {
    driverIconMarker();

    return Scaffold(
      key: scaffoldKey,

      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: MyDrawer(
          name: userName,
          email: userEmail,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(

            padding: EdgeInsets.only(bottom: newBottomPaddingMap, top: topMapPadding),
            mapType: currentMapType,
            myLocationButtonEnabled: true,
            initialCameraPosition: kLake,

            //zoomGesturesEnabled: true,

           // zoomControlsEnabled: true,


            polylines: newPolyLineSet,
            markers: newMarkerSets,
            circles: newCircleSets,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);

              newGoogleMapController = controller;

                 setState(() {
                   newBottomPaddingMap = 240;
                   topMapPadding = 70;
                 });

              blackThemeGoogleMap();

               userPosition();
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 24, right: 12),
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

          //custom button for drawer
          Positioned(
            top: 36,
            left: 22,
            child: GestureDetector(

              child: TweenAnimationBuilder<double>(
                duration:const Duration(seconds: 3),
                tween: Tween<double>(begin:0.0,
                    end: 1.0),
                builder: (BuildContext  context, double value,Widget? child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },

                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    openNavigationDrawer ? Icons.menu : Icons.cancel,
                    color: Colors.black54,
                  ),
                ),
              ),
              onTap: (){
                if(openNavigationDrawer) {

                  scaffoldKey.currentState!.openDrawer();
                } else{
                  MyApp.restartApp(context);
                  //SystemNavigator.pop();
                }
              },
            ),
          ),


          //UI for Searching Location
          Positioned(
            bottom: -2,
            right: 0,
            left: 0,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 130),
              child: Container(
                height: showingLocationContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),

                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: Column(
                    children: [
                      //from
                       LocationInfoRow(

                          icon: Icons.add_location,
                            label : "From",
                            location: Provider.of<AppInformation>(context).userPickUpLocation != null
                                      ? "${(Provider.of<AppInformation>(context).userPickUpLocation!.locationName!).substring(0,21)}..."
                                       : "Does not get any Location",

                          ),
                      const SizedBox(height: 12.0,),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,

                      ),
                      const SizedBox(height: 17.0,),
                      //To
                      GestureDetector(
                        onTap: () async {
                          var responseFromSearchScreen = await Navigator.push(context, MaterialPageRoute(builder:(c)=> const SearchPlaces()));

                          if(responseFromSearchScreen == "GotLocation"){

                            setState(() {
                              openNavigationDrawer = false;
                            });
                            //Draw route here
                            await drawRouteFromCurrentToDestination();
                          }
                        },
                        child: LocationInfoRow(
                          icon: Icons.add_location,
                          label: "To",
                          location: Provider.of<AppInformation>(context).userDropOffLocation != null
                          ? Provider.of<AppInformation>(context).userDropOffLocation!.locationName!
                           : "Your Destination",
                        ),
                      ),

                      const SizedBox(height: 12.0,),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,

                      ),
                      const SizedBox(height: 17.0,),
                      ElevatedButton(
                        onPressed: (){
                          if(Provider.of<AppInformation>(context, listen: false).userDropOffLocation == null){

                            Fluttertoast.showToast(msg: "Please Pick Destination.");


                          }else{

                              saveRequestInfo();
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          textStyle: const TextStyle(
                            fontSize: 16,
                              fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          "Request a Ride",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ),
          //UI for waiting response from driver
          Positioned(
            bottom: -2,
            right: 0,
            left: 0,
            child: Container(
              height: waitingResponseContainerHeight,
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                     color: Colors.black12,
                    spreadRadius: 10,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                   ),
                ],
              ),

                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                   child: AnimatedTextKit(
                    animatedTexts: [
                    FadeAnimatedText(
                      'Waiting for Response\n from Driver ',
                      textAlign: TextAlign.center,
                      duration :const Duration(seconds: 6),
                      textStyle: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54
                      ),
                    ),
                      ScaleAnimatedText(
                        ' Please wait... ',
                        textAlign: TextAlign.center,
                        duration :const Duration(seconds: 6),
                        textStyle: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54
                        ),
                      ),

                ],
              ),
                 ) ,
            ),
          ),

          //UI for assignedDriver
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: assignedDriverContainerHeight,
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                    boxShadow: [
                      BoxShadow(
                              color: Colors.black12,
                             offset: Offset(0, 3),
                             blurRadius: 7,
                             spreadRadius: 10,

                      ),

                    ],

              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:24, vertical:18),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          driverStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Divider(height: 2,thickness: 2,color: Colors.grey),
                      const SizedBox(height: 15),
                      //Driver name
                       Text(
                        "Driver name: $driverName",
                        textAlign: TextAlign.center,
                        style:  const TextStyle(
                          color: Colors.white54,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),


                      //Driver car
                       Text(
                        "vehicle type : $vehicleType",
                        textAlign: TextAlign.center,
                        style:  const TextStyle(
                          color: Colors.white54,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      const SizedBox(height: 15),
                      const Divider(height: 2,thickness: 2,color: Colors.grey),
                      const SizedBox(height: 14),

                      // call that Driver
                      Center(
                        child: ElevatedButton.icon(
                            onPressed: (){
                              makeCallToDriver(driverPhoneNumber);
                            },
                            icon: const Icon(
                                Icons.call_rounded,
                                size: 18,
                                color: Colors.white54,
                            ),
                            label: const Text(
                              "Call Driver",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white54,
                                fontSize: 18,
                              ),
                            ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            backgroundColor: Colors.lightBlue,
                          ),
                        ),
                      ),
                      ],
                  ),

              ),
            ),
          ),
        ],
      ),
    );
  }

  checkConnection() async{
    result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.none){

      isConnected = true;

    } else{
      isConnected = false;
      showDialogBox();


    } setState(() {

    });

  }

  showDialogBox() {
    if (!isDialogBox) {
      isDialogBox = true;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Internet'),
            content: const Text('Please Check Your Internet Connection'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  checkConnection();
                  isDialogBox = false;
                  Fluttertoast.showToast(msg: "Checking Connectivity...");
                },
                child: const Text('Retry'),
              ),
            ],
          );
        },
      );
    }
  }

  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event) async{
      checkConnection();
    });
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

  Future<void> checkAndRequestLocationPermission()async {



    permissionStatus = await Geolocator.requestPermission();

    if(permissionStatus == LocationPermission.denied){
      permissionStatus = await Geolocator.requestPermission();
    }

  }


  static const  kLake = CameraPosition(

      target: LatLng(37.43296265331129, -122.08832357078792),

      zoom: 12);



  void changerMapType(){
    setState(() {
      currentMapType = currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });



  }


  Future<void >userPosition() async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      userCurrentPosition = currentPosition;

      LatLng latLngPosition = LatLng(
          userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      CameraPosition cameraPosition = CameraPosition(
          target: latLngPosition, zoom: 12);

      newGoogleMapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition));


      // ignore: use_build_context_synchronously
      await Assistant.searchAddress(userCurrentPosition!, context);


      userName = userModelCurrentInformation!.name!;

      userEmail = userModelCurrentInformation!.email!;

      phone = userModelCurrentInformation!.phone!;

       FirebaseDatabase.instance.ref().child("users").child(currentFirebaseUser!.uid).child("ratings").once().then((value){
         if(value.snapshot.value != null){
           yourRatings = value.snapshot.value.toString();
         }
       });


      startOnlineDriversListener();
      // ignore: use_build_context_synchronously
      Assistant.readUserTripId(context);
    }catch(e){
      print("error updating user position: $e");
    }
  }

 Future<void> saveRequestInfo() async {
   try {
     rideRequestReference =
         FirebaseDatabase.instance.ref().child("All Ride Requests").push();

     var currentPosition = Provider
         .of<AppInformation>(context, listen: false)
         .userPickUpLocation;
     var dropOffPosition = Provider
         .of<AppInformation>(context, listen: false)
         .userDropOffLocation;

     Map currentPositionMap = {
       "latitude": currentPosition!.locationLatitude.toString(),
       "longitude": currentPosition.locationLongitude.toString(),
     };

     Map dropOffPositionMap =
     {
       "latitude": dropOffPosition!.locationLatitude.toString(),
       "longitude": dropOffPosition.locationLongitude.toString(),
     };
     Map userInfoMap = {
       "UserId": userModelCurrentInformation!.id,
       "current": currentPositionMap,
       "destination": dropOffPositionMap,
       "username": userModelCurrentInformation!.name,
       "time": DateTime.now().toString(),
       "userPhoneNumber": userModelCurrentInformation!.phone,
       "currentAddress": currentPosition.locationName,
       "destinationAddress": dropOffPosition.locationName,
       "driverId": "waiting...",
     };
     await rideRequestReference!.set(userInfoMap);

     rideRequestReference!.onValue.listen((event) async {
       if (event.snapshot.value == null) {
         return;
       }

       if ((event.snapshot.value as Map)["car_details"] != null) {
         setState(() {

           vehicleType =
               ((event.snapshot.value as Map)["car_details"]["car_type"])
                   .toString();
         });

       }

       if ((event.snapshot.value as Map)["driverName"] != null) {
         setState(() {
           driverName = (event.snapshot.value as Map)["driverName"].toString();

         });
       }
       if ((event.snapshot.value as Map)["driverPhone"] != null) {

         setState(() {
           driverPhoneNumber =
               (event.snapshot.value as Map)["driverPhone"].toString();
         });
       }
       if ((event.snapshot.value as Map)["rideRequestStatus"] != null) {
         newRideStatus =

             (event.snapshot.value as Map)["rideRequestStatus"].toString();
       }

       if ((event.snapshot.value as Map)["driverLocation"] != null) {

          driverCurrentPositionLat = double.parse(

             (event.snapshot.value as Map)["driverLocation"]["latitude"]
                 .toString());

          driverCurrentPositionLng = double.parse(

             (event.snapshot.value as Map)["driverLocation"]["longitude"]
                 .toString());


         driverCurrentLocationLatLng = LatLng(
             driverCurrentPositionLat!, driverCurrentPositionLng!);

         //status = Accepted
         if (newRideStatus == "Accepted") {

           try{

             if(rideRequestPositionInfo == true){
               rideRequestPositionInfo = false;

               LatLng userPickUpLocation = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

               var directionInfo = await Assistant.getDirectionDetailsCurrentToDestination(driverCurrentLocationLatLng, userPickUpLocation);
               if(directionInfo == null){
                 return;
               }
               setState(() {
                 driverStatus = "Driver is coming in: ${directionInfo.duration_text}";

               });

               rideRequestPositionInfo = true;
             }

           }catch(e){
             print("Error while updating driver location: $e");
           }
         }
         //status = arrived
         if (newRideStatus == "arrived") {

           setState(() {
             driverStatus = "Driver has arrived";
           });
         }

         //status = onTrip
         if (newRideStatus == "onTrip") {
           //Sometimes this function did not execution by calling from here
           //So i put it here directly
           try{
             if(rideRequestPositionInfo == true){

               LatLng previousLatLng = const LatLng(0, 0);

               streamSubscriptionLiveLocation = Geolocator.getPositionStream().listen((Position position)async {

                 driverCurrentLocationLatLng = position;
                 LatLng livePosition = LatLng(position.latitude, position.longitude);

                 List<Placemark> placeMark = await placemarkFromCoordinates(
                   position.latitude,
                   position.longitude,

                 );
                 String humanReadableAddress = placeMark.isNotEmpty
                     ?'${placeMark[0].name},${placeMark[0].locality},${placeMark[0].subLocality}, ${placeMark[0].administrativeArea}'
                     : 'Unknown Address';

                 Marker iconMarker = Marker(

                   markerId: const MarkerId("Marker"),

                   position: livePosition,
                   icon: animatedMarker!,

                   infoWindow:  InfoWindow(title:humanReadableAddress , snippet: "Driver Current Location"),

                 );
                 setState(() {
                   CameraPosition cameraPosition = CameraPosition(
                       target: livePosition, zoom: 13);

                   newGoogleMapController!
                       .animateCamera(CameraUpdate
                       .newCameraPosition(cameraPosition));

                   //remove previous icons
                   driverMarker.removeWhere((element) => element.markerId.value == "Marker");


                   driverMarker.add(iconMarker);
                 });
                 previousLatLng = livePosition;

               });
               rideRequestPositionInfo = false;

               var dropOffPosition = Provider.of<AppInformation>(context, listen: false).userDropOffLocation;
               LatLng userDropOffLocation = LatLng(dropOffPosition!.locationLatitude!, dropOffPosition.locationLongitude!);


               var directionInfo = await Assistant.getDirectionDetailsCurrentToDestination(driverCurrentLocationLatLng, userDropOffLocation);
               if(directionInfo == null) {
                 return;
               } else{
                 setState(() {
                   driverStatus = "Towards Your Destination: ${directionInfo.duration_text}";
                 });
               }
               rideRequestPositionInfo = true;
             }

           }catch(e){
             print("Error in updating driver location: $e");
           }

         }
         //status = tripEnded
         if (newRideStatus == "trip Completed") {

           if ((event.snapshot.value as Map)["totalTripAmount"] != null) {
             double totalTripAmount = double.parse(

                 (event.snapshot.value as Map)["totalTripAmount"].toString());

             // ignore: use_build_context_synchronously
             var userResponse = await showDialog(
               context: context,

               barrierDismissible: false,
               builder: (BuildContext context) =>
                   TotalAmountDialog(totalTripAmount: totalTripAmount),
             );
             if (userResponse == "AmountPaid") {
               //rate the driver

               if ((event.snapshot.value as Map)["driverId"] != null) {

                 String driverId = (event.snapshot.value as Map)["driverId"]
                     .toString();

                 // ignore: use_build_context_synchronously
                 Navigator.push(context, MaterialPageRoute(

                     builder: (c) => RateTheDriver(driverId: driverId)));

                 rideRequestReference!.onDisconnect();
                 rideStreamSubscription!.cancel();
               }
             }
           }
         }
       }
     });

     //driverList.clear();
     nearestOnlineDriverList = GeoFireAssistant.onlineNearestDriversList;

     initiateDriverSelectionProcess();
   }catch(e){
     print("Error in saving rideRequest: $e");
   }
 }


 Future<void> sendNotificationToChosenDriver(String pickedDriverId) async {
   try{
    //assign rideRequestId to newRide in drivers Parent node
      await FirebaseDatabase.instance.ref()

        .child("drivers").child(pickedDriverId)

        .child("newRide").set(rideRequestReference!.key);

    //push notification server
    FirebaseDatabase.instance.ref()

        .child("drivers").child(pickedDriverId)
        .child("token").once().then((value) {

      if(value.snapshot.value != null){
        String driverToken = value.snapshot.value.toString();

        Assistant.sendingNotificationToSelectedDriver(driverToken, rideRequestReference!.key.toString(), context);

        Fluttertoast.showToast(msg: "Notification Sent to the Driver.");
      } else{
        Fluttertoast.showToast(msg: "This Driver is not available, choose another one.");
        return;
      }
    });

  }catch(e){
   print("Error while sending notification");
   }
 }


  Future<void> getOnlineDriverInfo(List onlineDriversList) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("drivers");

    for (var driver in onlineDriversList) {
      var value = await reference.child(driver.driverId.toString()).once();

      setState(() {
        driverInfoKey = value.snapshot.value;
        print("before:  $driverList");
        driverList.add(driverInfoKey);
        print("after:  $driverList");
      });
    }
  }

 void waitingForResponseFromDriver() =>  setState(() {
   showingLocationContainerHeight = 0;
   waitingResponseContainerHeight = 220;
 });


 Future<void> initiateDriverSelectionProcess() async {
    try {
      if (nearestOnlineDriverList.isEmpty) {
        rideRequestReference!.remove();

        setState(() {
          newPolyLineSet.clear();
          newCircleSets.clear();
          newMarkerSets.clear();
          newPolyLineSet.clear();
        });
        Fluttertoast.showToast(msg: "There is no online Driver");

        Future.delayed(const Duration(milliseconds: 3000), () {
          // MyApp.restartApp(context);
          SystemNavigator.pop();
        });


        return;
      }
      //wait
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c){
            return ProgressDialog(message: "Progressing Please wait... ",);
          }
      );

      await getOnlineDriverInfo(nearestOnlineDriverList);

      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      // ignore: use_build_context_synchronously
      var response = await Navigator.push(
          context, MaterialPageRoute(
          builder: (c) =>
              SelectOnlineDriver(rideRequestReference: rideRequestReference)));


      if (response == "DriverChosen") {
        FirebaseDatabase.instance.ref().child("drivers")
            .child(pickedDriverId!).once()
            .then((value) {
          if (value.snapshot.value != null) {
            sendNotificationToChosenDriver(pickedDriverId!);

            waitingForResponseFromDriver();

            FirebaseDatabase.instance
                .ref()
                .child("drivers")
                .child(pickedDriverId!)
                .child("newRide")
                .onValue
                .listen((value) {
              // if the driver cancel the Ride Request

              if (value.snapshot.value == "Ready for Ride") {
                Fluttertoast.showToast(msg: "Driver has cancelled the Ride.");
                driverList.clear();

                Future.delayed(const Duration(milliseconds: 3000), () {
                  Fluttertoast.showToast(msg: "App will restart.");
                  SystemNavigator.pop();
                });
              }
              //if the driver accept the Ride Request
              if (value.snapshot.value == "accepted") {
                showingAssignedDriver();
              }
            });
          } else {
            Fluttertoast.showToast(msg: "Driver does not exist...");
          }
        });
      }
    }catch(e) {
      print("Error while Searching Online Driver: $e");
    }
    }


 void showingAssignedDriver(){
    showingLocationContainerHeight = 0;
    waitingResponseContainerHeight = 0;
    assignedDriverContainerHeight = 240;


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


  Future<void> drawRouteFromCurrentToDestination() async{
   try{

     var currentPosition = Provider.of<AppInformation>(context, listen: false).userPickUpLocation;

     var destinationPosition = Provider.of<AppInformation>(context, listen: false).userDropOffLocation;


     var currentLatLng = LatLng(currentPosition!.locationLatitude!, currentPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLatitude!, destinationPosition.locationLongitude!);

    showDialog(
         context: context,
         builder: (BuildContext context) => ProgressDialog(message: "Please Wait...",),
     );

    var directionInfo = await Assistant.getDirectionDetailsCurrentToDestination(currentLatLng, destinationLatLng);
      setState(() {
        tripInfo = directionInfo;

      });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPointResult = pPoints.decodePolyline(directionInfo!.e_points!);

     polyLineList.clear();

    if(decodedPointResult.isNotEmpty)
    {
      for (int i = 0; i < decodedPointResult.length; i++) {
        var pointLatLng = decodedPointResult[i];

        polyLineList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }


    newPolyLineSet.clear();

    setState(() {
      Polyline polyLine = Polyline(
        color: Colors.blue,
        polylineId: const PolylineId("PolylineId"),
        jointType: JointType.bevel,
        points: polyLineList,
        startCap: Cap.roundCap,
        endCap: Cap.squareCap,
        geodesic: true,

      );
      newPolyLineSet.add(polyLine);
    });
      //zoom out animation
    LatLngBounds boundLatLng;

    if(currentLatLng.latitude > destinationLatLng.latitude && currentLatLng.longitude > destinationLatLng.longitude ){
      boundLatLng = LatLngBounds(southwest: destinationLatLng, northeast: currentLatLng);

    } else if(currentLatLng.longitude > destinationLatLng.longitude){
      boundLatLng = LatLngBounds(

          southwest: LatLng(currentLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, currentLatLng.longitude),
      );

    } else if(currentLatLng.latitude > destinationLatLng.latitude){
      boundLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, currentLatLng.longitude),
          northeast: LatLng(currentLatLng.latitude, destinationLatLng.longitude),
      );

    } else{
      boundLatLng = LatLngBounds(southwest: currentLatLng, northeast: destinationLatLng);
    }
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundLatLng, 60));

    Marker currentLocationMarker = Marker(
        markerId: const MarkerId("CurrentLocationID"),
        position: currentLatLng,
        infoWindow: InfoWindow(title: currentPosition.locationName, snippet: "Your Current Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("DestinationLocationID"),
      position: destinationLatLng,
      infoWindow: InfoWindow(title: destinationPosition.locationName, snippet: "Your Destination"),
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
      newMarkerSets.add(currentLocationMarker);
      newMarkerSets.add(destinationMarker);

    });

    setState(() {
      newCircleSets.add(currentLocationCircle);
      newCircleSets.add(destinationLocationCircle);
    });


  }catch(e){
   print("Error while draw the route: $e");
   }
  }

  //Display all nearest online drivers
 void startOnlineDriversListener() {
   try{
    Geofire.initialize("onlineDrivers");

     //Search on 7 km
    Geofire.queryAtLocation(
        userCurrentPosition!.latitude, userCurrentPosition!.longitude, 7)!
        .listen((map) {

      print(map);

      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {

          case Geofire.onKeyEntered:
            OnlineNearestDrivers onlineNearestDrivers = OnlineNearestDrivers(

                driverId: map['key'],
                locationLatitude: map['latitude'],

            locationLongitude : map['longitude'],
            );

            GeoFireAssistant.onlineNearestDriversList.add(onlineNearestDrivers);

            if(onlineDriverKeyLoaded == true ){
              displayOnlineDriversOnUsersMap();
            }
            break;

          case Geofire.onKeyExited:

            GeoFireAssistant.removeOfflineDriverFromList(map['key']);

            displayOnlineDriversOnUsersMap();
            break;

          case Geofire.onKeyMoved:
             onlineNearestDrivers = OnlineNearestDrivers(
               driverId : map['key'],
              locationLatitude : map['latitude'],
              locationLongitude : map['longitude'],

            );
            GeoFireAssistant.onlineNearestDriversList.add(onlineNearestDrivers!);

            GeoFireAssistant.updateOnlineNearestDriversList(onlineNearestDrivers!);

            displayOnlineDriversOnUsersMap();

            break;

          case Geofire.onGeoQueryReady:
            onlineDriverKeyLoaded = true;

            displayOnlineDriversOnUsersMap();

            break;
        }
      }
        setState(() {});
    });
  }catch(e){
   print("Error while initialize the driver: $e");
   }
 }


  // Function to make a phone call
  Future<void> makeCallToDriver(String phoneNumber) async {
    final Uri makeCall = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunch(makeCall.toString())) {
      await launch(makeCall.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }



 void displayOnlineDriversOnUsersMap(){
   try{
    setState(() async {

      newMarkerSets.clear();
      newCircleSets.clear();

      Set<Marker> driverMarketSets = Set<Marker>();

      for(OnlineNearestDrivers eachDriver in GeoFireAssistant.onlineNearestDriversList){
        LatLng eachOnlineDriverLocation = LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);

       List<Placemark> placeMark = await placemarkFromCoordinates(
         eachDriver.locationLatitude!,
         eachDriver.locationLongitude!,

       );
        String humanReadableAddress = placeMark.isNotEmpty
            ?'${placeMark[0].name},${placeMark[0].locality},${placeMark[0].subLocality}, ${placeMark[0].administrativeArea}'
            : 'Unknown Address';

        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          infoWindow:  InfoWindow(title: humanReadableAddress ,snippet: "Driver Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          position: eachOnlineDriverLocation,
          rotation: 360,


        );
        driverMarketSets.add(marker);
      }
      setState(() {

        newMarkerSets = driverMarketSets;
      });
    });

  }catch(e){
   print("Error while Display drivers: $e");
   }
 }


}
