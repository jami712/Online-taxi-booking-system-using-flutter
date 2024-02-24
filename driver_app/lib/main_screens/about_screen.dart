import 'dart:io';

import 'package:driver_app/main_screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}




class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,
        title: const Text("Go to Main Page"),
        leading: IconButton(

          icon:const Icon(Icons.arrow_back),
          onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (c) => const MainScreen()));
          },
        ),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:  AssetImage("images/car1.png"),
                  fit: BoxFit.contain,
                )
              ),
            ),
            const SizedBox(height: 20,),
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Online Taxi Booking System",

                  style: TextStyle(
                    fontSize: 24,

                    fontWeight: FontWeight.bold,

                    color: Colors.white,
                  ),
                ),
                 const SizedBox(height: 8,),
                const Text(
                  "App Name: Driver App",

                  style: TextStyle(
                    fontSize: 24,

                    fontWeight: FontWeight.bold,

                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8,),

                 const Text(
                  "Developer: Mudassir Jamal",

                  style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.bold,

                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10,),
                Center(
                  child: ElevatedButton(
                      onPressed: (){
                        shareApp();
                      },
                      child: const Text("Share App"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  void shareApp(){
    String downloadLink = 'https://drive.google.com/file/d/1TUa7_azxvEd0RSBjvjTmT-2fQg2r2IMU/view?usp=sharing';
    String message = 'Download Driver App: $downloadLink';
    Share.share(message);

  }


 }
