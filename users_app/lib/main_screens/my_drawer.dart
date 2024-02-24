import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:users_app/SplashScreen/splash_screen.dart';
import 'package:users_app/main_screens/about_screen.dart';
import 'package:users_app/main_screens/trip_history.dart';
import 'package:users_app/main_screens/user_profile.dart';


import '../global/global.dart';

class MyDrawer extends StatefulWidget {
  //const MyDrawer({super.key});

  String? name;
  String? email;
  MyDrawer({super.key, this.name, this.email});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: ListView(
        children: [
          Container(
            height: 150,
            color: Colors.grey,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black54),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage:NetworkImage("https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-1024.png"),
                  ),
                  const SizedBox(width: 16,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          widget.name.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Text(
                        widget.email.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

           const SizedBox(height: 12.0,),

          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const TripsHistory()));

            },
            child:  const ListTile(
              leading:Icon(Icons.history, color: Colors.white54,),
              title: Text(
                "History",
               style: TextStyle(
                 color: Colors.white54,
               ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const UserProfileScreen()));

            },
            child:  const ListTile(
              leading:Icon(Icons.person, color: Colors.white54,),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const AboutScreen()));
            },
            child:  const ListTile(
              leading:Icon(Icons.info, color: Colors.white54,),
              title: Text(
                "About",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              showLogoutConfirmationDialog(context);
            },
            child:  const ListTile(
              leading:Icon(Icons.logout, color: Colors.white54,),
              title: Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              shareApp();
            },
            child:  const ListTile(
              leading:Icon(Icons.share, color: Colors.white54,),
              title: Text(
                "Share App",
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void shareApp(){
    String downloadLink = 'https://drive.google.com/file/d/1GeMWnKuGz4IYjuWBraI66GgJTu9oW2PR/view?usp=sharing';
    String message = 'Download User App: $downloadLink';
    Share.share(message);

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
