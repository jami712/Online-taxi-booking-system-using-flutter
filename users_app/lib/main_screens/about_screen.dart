import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:users_app/main_screens/main_screen.dart';
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
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Online Taxi Booking System",

                  style: TextStyle(
                    fontSize: 24,

                    fontWeight: FontWeight.bold,

                    color: Colors.white,
                  ),
                ),
                 SizedBox(height: 8,),
                Text(
                  "App Name: User App",

                  style: TextStyle(
                    fontSize: 24,

                    fontWeight: FontWeight.bold,

                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8,),
                 Text(
                  "Developer: Mudassir Jamal",

                  style: TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.bold,

                    color: Colors.white,
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
}
