
import 'package:driver_app/splash_screen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}


class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModel = TextEditingController();
  TextEditingController carNumber = TextEditingController();
  TextEditingController carColor = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(

             children: [
           const SizedBox(height: 23,),
           Padding(

             padding: const EdgeInsets.all(21.0),

             child: Image.asset("images/logo.png"),

           ),
               const SizedBox(height: 9,),

               const Text(

                 "Write Car details here",
                 style: TextStyle(
                   color: Colors.grey,
                   fontWeight: FontWeight.bold,
                   fontSize: 25,

                 ),
               ),
               TextField(
                 controller: carModel,
                 style: const TextStyle(
                   color: Colors.grey,
                 ),
                 decoration:const InputDecoration(
                   labelText: "Car Model",
                   hintText: "Car Model",

                   focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.grey),
                   ),

                   enabledBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.grey),

                   ),

                   hintStyle: TextStyle(
                     color:  Colors.white24,
                     fontSize: 11,
                   ),
                   labelStyle: TextStyle(
                     color:  Colors.white24,
                     fontSize: 15,
                   ),
                 ),
               ),
               TextField(

                 controller: carNumber,
                 style: const TextStyle(
                   color: Colors.grey,
                 ),
                 decoration:const InputDecoration(

                   labelText: "Car Number",
                   hintText: "Car Number",

                   focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.grey),
                   ),

                   enabledBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.grey),

                   ),

                   hintStyle: TextStyle(
                     color:  Colors.white24,
                     fontSize: 11,
                   ),
                   labelStyle: TextStyle(
                     color:  Colors.white24,
                     fontSize: 15,
                   ),
                 ),
               ),
               TextField(

                 controller: carColor,
                 style: const TextStyle(

                   color: Colors.grey,
                 ),
                 decoration:const InputDecoration(

                   labelText: "Car Color",
                   hintText: "Car Color",

                   focusedBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.grey),
                   ),

                   enabledBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.grey),

                   ),

                   hintStyle: TextStyle(
                     color:  Colors.white24,
                     fontSize: 11,
                   ),
                   labelStyle: TextStyle(
                     color:  Colors.white24,
                     fontSize: 15,
                   ),
                 ),
               ),
               DropdownButton(

                 dropdownColor: Colors.black,

                 hint: const Text(

                   "Please Choose Car Type",
                   style: TextStyle(
                     fontSize: 13,

                     color: Colors.grey,
                   ),
                 ),
                 value: selectedVehicleType,

                 onChanged: (value){
                   setState(() {

                     selectedVehicleType = value.toString();

                   });
                 },
                 items: vehicleTypesList.map((vehicle){
                   return DropdownMenuItem(
                     value: vehicle,

                     child: Text(
                       vehicle,

                       style: const TextStyle(
                           color: Colors.grey),
                     ),
                   );
                 }).toList(),
               ),
               const SizedBox(height: 19,),
               ElevatedButton(

                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.lightGreenAccent,
                 ),
                 child: const Text(
                   "Next",
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 19,
                   ),
                 ),

                 onPressed: (){

                   if(carColor.text.isNotEmpty &&
                       carNumber.text.isNotEmpty &&
                       carModel.text.isNotEmpty &&
                       selectedVehicleType != null){
                     saveCarInformation();
                   }

                 },
               ),

       ],
     ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }


  List<String>vehicleTypesList= ["van","car","bike"];

  String? selectedVehicleType;

  saveCarInformation(){
    Map driverCarInfoMap = {
      "car_color":  carColor.text.trim(),

      "car_number":  carNumber.text.trim(),
      "car_model":  carModel.text.trim(),

      "car_type":  selectedVehicleType,
    };
    DatabaseReference driverReference =FirebaseDatabase.instance.ref().child("drivers");

    driverReference.child(currentUser!.uid)
        .child("car_details")
        .set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Car details has been saved.");
    Navigator.push(
        context,
        MaterialPageRoute(builder: (c)=> const SplashScreen()
        ));
  }
}
