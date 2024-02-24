import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global.dart';

class RateTheDriver extends StatefulWidget {
  String? driverId;

  RateTheDriver({super.key, this.driverId});

  @override
  State<RateTheDriver> createState() => _RateTheDriver();


}
class _RateTheDriver extends State<RateTheDriver> {
  @override
  Widget build(BuildContext context){
    return Scaffold(

      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),

        ),
        backgroundColor: Colors.transparent,

        shadowColor:  Colors.grey,
        child: Container(

          width: double.infinity,
          margin:  const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: Colors.white54,

            borderRadius: BorderRadius.circular(8),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const SizedBox(height: 12,),
              const Text("Rate the driver Please",
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              ),
              const SizedBox(height: 20,),
              const Divider(
                height: 4,
                thickness: 2,
              ),
              const SizedBox(height: 20,),
              SmoothStarRating(
                rating: ratingStars,
                allowHalfRating: false,
                starCount: 5,
                size: 30,
                onRatingChanged: (value){
                  setState(() {
                    ratingStars = value;
                  });

                  if( ratingStars == 1 ){
                    setState(() {
                      titleOfRatingStars = "Very Bad";
                    });
                  }
                  if( ratingStars == 2 ){
                    setState(() {
                      titleOfRatingStars = " Bad";
                    });
                  }
                  if( ratingStars == 3 ){
                    setState(() {
                      titleOfRatingStars = "Good";
                    });
                  }
                  if( ratingStars == 4 ){
                    setState(() {
                      titleOfRatingStars = "Very Good";
                    });
                  }
                  if( ratingStars == 5 ){
                    setState(() {
                      titleOfRatingStars = "OutStanding";
                    });
                  }
                },
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
              ElevatedButton(
                  onPressed:(){

                    DatabaseReference driverRatingReference = FirebaseDatabase.instance.ref().child("drivers").child(widget.driverId!).child("ratings");

                    driverRatingReference.once().then((value)  {
                      if(value.snapshot.value != null){

                        double oldRatings = double.parse(value.snapshot.value.toString());

                        double newRatings = (oldRatings + ratingStars)/2;

                        driverRatingReference.set(newRatings.toString());

                        Fluttertoast.showToast(msg: "Thanks,");

                        SystemNavigator.pop();
                      } else {

                        driverRatingReference.set(ratingStars.toString());
                        Fluttertoast.showToast(msg: "Thanks,");

                        SystemNavigator.pop();
                      }
                    });
                  },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  backgroundColor: Colors.blue,
                ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
              ),
              const SizedBox(height: 12,),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

}
