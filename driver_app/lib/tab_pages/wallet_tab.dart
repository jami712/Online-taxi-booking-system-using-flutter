import 'package:driver_app/global/global.dart';
import 'package:driver_app/info_handler/app_information.dart';
import 'package:driver_app/main_screens/trip_history.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

class WalletTabPage extends StatefulWidget {
  const WalletTabPage({super.key});

  @override
  State<WalletTabPage> createState() => _WalletTabPage();
}

class _WalletTabPage extends State<WalletTabPage> {

  double driverRating = 0;
  String titleOfRatingStars = "Good";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

      driverRating = double.parse(ratings);

      print("Driver ratings: $driverRating");
    });
    setTheRatingsTitle();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.grey,

      child: Column(
        children: [
          //Total Earnings

          Container(
            width: double.infinity,
            color: Colors.black54,

            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(

                children: [
                  const Text(
                    "Total Earnings",

                    style: TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),

                  ),
                  const SizedBox(height: 8,),
                  Text(
                    "${Provider.of<AppInformation>(context, listen: false).driverTotalEarnings} ₺",

                    style:const  TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Total trips
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
              ),
                onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const TripsHistory()));
                },
              child: const Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(Icons.car_rental, size: 35,),
                  SizedBox(width: 12,),
                   Text("Completed trips",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                ],
              ),
                ),
          ),
          const SizedBox(height: 40,),


             Container(

              width: double.infinity,

              decoration: BoxDecoration(

                color: Colors.black54,

                borderRadius: BorderRadius.circular(40),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const SizedBox(height: 12,),

                  const Text("Your Ratings",
                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Divider(
                    height: 4,
                    thickness: 2,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 20,),

                  SmoothStarRating(
                    rating: driverRating,
                    allowHalfRating: false,
                    starCount: 5,
                    size: 30,

                  ),
                  const SizedBox(height: 10,),
                  Text(
                    titleOfRatingStars,


                    style:const TextStyle(
                      color: Colors.blue,

                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 16,),

                ],
              ),
            ),
        ],

      ),
    );

  }
  setTheRatingsTitle(){
    if(driverRating == 1) {
      setState(() {
        titleOfRatingStars = "very bad";
      });
    } else if(driverRating == 2){
      setState(() {
        titleOfRatingStars = " Bad";
      });
    } else if(driverRating == 3){
      setState(() {
        titleOfRatingStars = " Good";
      });
    } else if(driverRating == 4){
      setState(() {
        titleOfRatingStars = " Vey Good";
      });
    } else if(driverRating == 5){
      setState(() {
        titleOfRatingStars = " OutStanding";
      });
    } else{
      setState(() {
        titleOfRatingStars = " ";
      });
    }
    }
  }

