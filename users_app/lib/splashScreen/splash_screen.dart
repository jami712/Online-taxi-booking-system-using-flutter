import 'dart:async';

import 'package:flutter/material.dart';
import 'package:users_app/main_screens/main_screen.dart';

import '../assistants/assistant_methods.dart';
import '../authentication/login.dart';
import '../global/global.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    super.initState();
    checkCurrentUserAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Material(

      child: Container(

        color: Colors.black,
        child: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                duration:const Duration(seconds: 3),
                tween: Tween<double>(begin:0.0,
                    end: 1.0),
                builder: (BuildContext  context, double value,Widget? child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },

                child: Image.asset("images/logo.png"),
              ),


              const SizedBox(height: 10),

              const Text(
                "Welcome to User App",
                style: TextStyle(

                  fontSize: 24,
                  color: Colors.white,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )

        ),
      ),
    );
  }

checkCurrentUserAndNavigate(){

  if(firebaseAuthentication.currentUser != null){
    Assistant.readCurrentOnLineUsersInfo();

  } else{
    null;
  }
  Timer(const Duration(seconds:3),() async {
    // ignore: await_only_futures
    if(await firebaseAuthentication.currentUser != null){
      currentFirebaseUser = firebaseAuthentication.currentUser;
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(
              builder:(c)=> const MainScreen()));

    } else{
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(
              builder:(c)=> const LoginScreen()));
    }


  });
}
}
