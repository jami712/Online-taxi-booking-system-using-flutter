import 'dart:async';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:users_app/models/direction_details.dart';

import '../models/user_model.dart';


final FirebaseAuth firebaseAuthentication = FirebaseAuth.instance;
User? currentFirebaseUser;

UserModel? userModelCurrentInformation;

List driverList = [];
// ignore: prefer_typing_uninitialized_variables
var driverInfoKey;
String? pickedDriverId = " ";
String messagingServerToken = "key=AAAA6u9zUyM:APA91bEQ66Og2_wNcEprjUwHAikgSADnpFBQRjTuDO1X7f7y0C-ZnLPOf5vEfrx7yXCFDMek-uFmdt1A9LFZ9jIAts5xuwyicz0z2f-WTW92cd7ujUxIK3tp8fhoRufZY52LYWyyLwr7";
DirectionDetails? tripInfo;
String userDestination = "";
String vehicleType = "";
String driverName = "";
String driverPhoneNumber = "";
double ratingStars = 0.0;
String titleOfRatingStars = "";
String mapKey = "";
String amount = "";
StreamSubscription<Position>? streamSubscriptionLiveLocation;
bool isConnected = false;
bool isDialogBox = false;
late ConnectivityResult result;
late StreamSubscription subscription;
String userName = "Your Name";
String userEmail = "Your Email";
String phone = "Your Phone";
String yourRatings = "0";
MapType currentMapType = MapType.normal;





