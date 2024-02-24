import 'package:driver_app/global/global.dart';
import 'package:driver_app/main_screens/about_screen.dart';
import 'package:driver_app/main_screens/user_info_ui.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Stack(

        children: [
          Positioned(
            top: 36,
            right: 22,
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

                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.info,
                    color: Colors.black54,
                  ),
                ),
              ),
              onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (c) => const AboutScreen()));
                },
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 64,
                  backgroundImage:NetworkImage("https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-1024.png"),
                ),
              ),
              const SizedBox(height: 10,),
              // user name
               Text(
                 driverName,

                style: const  TextStyle(
                  fontWeight: FontWeight.bold,

                  fontSize: 30,
                  color: Colors.white,
                ),
              ),


              const SizedBox(height: 20,width: 30,),
              const Divider(
                color: Colors.white10,
                height: 4,
                thickness: 4,
              ),
              //Phone
              UserInfoUi(
                info: driverPhone,
                iconData: Icons.phone_android,
              ),
              //Email
              UserInfoUi(
                info: driverEmail,
                iconData: Icons.email_outlined,
              ),
              //car_type
              UserInfoUi(
                info: "car type: $carType\n car model: ${driversData.car_model}\n car number: ${driversData.car_number}",
                iconData: Icons.car_rental_rounded,
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ElevatedButton(
                        onPressed: (){
                         showLogoutConfirmationDialog(context);
                        },
                       style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blue,
                       ),

                        child: const Text("LogOut"),
                    ),
                    const SizedBox(width: 30,),
                    ElevatedButton(
                      onPressed: () {
                        showDeleteConfirmationDialog(context);

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,

                      ),
                      child: const Text(
                        "Delete Account",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );

  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to Delete your Account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform logout
                FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).remove();
                firebaseAuthentication.signOut();
                SystemNavigator.pop();
              },
              child: const Text("Delete Account"),
            ),
          ],
        );
      },
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform logout
                firebaseAuthentication.signOut();
                SystemNavigator.pop();
              },
              child: const Text("Log Out"),
            ),
          ],
        );
      },
    );
  }

}
