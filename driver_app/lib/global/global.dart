import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driver_app/models/driver_data.dart';
import 'package:driver_app/models/user_ride_request_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/user_model.dart';


final FirebaseAuth firebaseAuthentication = FirebaseAuth.instance;
User? currentUser;
UserModel? userModelCurrentInformation;
StreamSubscription<Position>? streamSubscriptionLocation;
StreamSubscription<Position>? streamSubscriptionLiveLocation;
bool isActive = false;
String statusText = "Go Online";
Color statusColor = Colors.white10;
Position? userCurrentPosition;
DriversData driversData = DriversData();
String userPhoneNumber = "";
String carType = "";
String driverName = "Your Name";
String driverPhone = "Your Phone";
String driverEmail = "Your Email";
String mapKey = "AIzaSyAXHgBfC3EnGQKUSSdNA6uaClUJmppZbOI";
String ratings = "0";
double ratingStars = 0.0;
String titleOfRatingStars = "";
bool isConnected = false;
bool isDialogBox = false;
late ConnectivityResult result;
late StreamSubscription subscription;
MapType currentMapType = MapType.normal;
String userRatings = "0";

