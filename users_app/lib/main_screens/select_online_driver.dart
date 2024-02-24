import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter/services.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/main.dart';

class SelectOnlineDriver extends StatefulWidget {
  //const SelectOnlineDriver({super.key});

  DatabaseReference? rideRequestReference;

  SelectOnlineDriver({super.key,
    this.rideRequestReference,
  });

  @override
  State<SelectOnlineDriver> createState() => _SelectOnlineDriverState();
}

class _SelectOnlineDriverState extends State<SelectOnlineDriver> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Online Drivers",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
              Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            driverList.remove(driverInfoKey);
            driverList.clear();
            widget.rideRequestReference!.remove();

            Fluttertoast.showToast(msg: "Ride has been cancelled.");

           // MyApp.restartApp(context);
            SystemNavigator.pop();
          },
        ),
      ),
      backgroundColor: Colors.black45,

      body: ListView.builder(

        itemCount: driverList.length,
        itemBuilder: (BuildContext context, int i){
          return Card(
            color: Colors.grey,

            shadowColor: Colors.lightBlue,
            elevation: 3,

            margin: const EdgeInsets.all(8),

            child: ListTile(

              onTap: (){
                setState(() {

                  pickedDriverId = driverList[i]["id"].toString();
                });

                Navigator.pop(context,"DriverChosen");
                driverList.clear();
              },
              leading: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Image.asset(
                  "images/${driverList[i]["car_details"]["car_type"]}.png",

                  width: 70,

                ),
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    driverList[i]["name"],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    driverList[i]["car_details"]["car_model"],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                    ),
                  ),
                  SmoothStarRating(
                    rating: driverList[i]["ratings"] == null ? 0.0 : double.parse(driverList[i]["ratings"]),
                    color: Colors.black,
                    borderColor: Colors.black,
                    allowHalfRating: true,
                    starCount: 5,
                    size: 14,

                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    "₺ " + calculateAmountAccordingToCarType(i),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2,),
                  Text(
                    tripInfo != null
                        ? tripInfo!.duration_text!
                        : "",
                    style:const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2,),
                  Text(
                    tripInfo != null
                        ? tripInfo!.distance_text!
                        : "",
                    style:const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );

        }
      ),
    );
  }

 String calculateAmountAccordingToCarType(int index){
    try {
      if (tripInfo != null) {
        String carType = driverList[index]["car_details"]["car_type"]
            .toString();

        if (carType == "van") {
          amount =
              (Assistant.calculateAmountFromCurrentToDestination(tripInfo!) + 2)
                  .toString();
        }

        else if (carType == "car") {
          amount =
              (Assistant.calculateAmountFromCurrentToDestination(tripInfo!))
                  .toString();
        }
        else if (carType == "bike") {
          amount =
              (Assistant.calculateAmountFromCurrentToDestination(tripInfo!) / 2)
                  .toString();
        }
      }
    }catch(e){
      print("Error in calculating Amount: $e");

    }
    return amount;
  }
}
