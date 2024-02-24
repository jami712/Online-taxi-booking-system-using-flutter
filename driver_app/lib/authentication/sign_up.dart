// ignore_for_file: use_build_context_synchronously

import 'package:driver_app/authentication/car_info.dart';
import 'package:driver_app/authentication/login.dart';
import 'package:driver_app/main_screens/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';

//import 'car_info.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});



  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController nameText = TextEditingController();

  TextEditingController emailText = TextEditingController();

  TextEditingController phoneText = TextEditingController();

  TextEditingController passwordText = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(15.0),

          child: Column(

            children: [
              const SizedBox(height: 11,),
              Padding(
                padding: const EdgeInsets.all(21.0),

                child: Image.asset("images/logo.png"),

              ),

              const SizedBox(height: 11,),

              const Text(
                "Register as a Driver",
                style: TextStyle(
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,                  fontSize: 25,

                ),
              ),
              TextField(
                controller: nameText,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration:const InputDecoration(
                  labelText: "Name",
                  hintText: "Name",
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
                controller: emailText,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration:const InputDecoration(
                  labelText: "Email",
                  hintText: "Email",
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
                controller: phoneText,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration:const InputDecoration(
                  labelText: "Phone",
                  hintText: "Phone",
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
                controller: passwordText,
                obscureText: true,
                keyboardType: TextInputType.text,


                style: const TextStyle(
                  color: Colors.grey,
                ),

                decoration:const InputDecoration(

                  labelText: "Password",
                  hintText: "Password",

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
              const SizedBox(height: 20,),
              ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                ),
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                  ),
                ),

                onPressed: (){
                  validationForm();

                },
              ),
              TextButton(
                child: const Text(
                  "Already have an account? Login here.",
                  style: TextStyle(color: Colors.white24),
                ) ,
                onPressed: (){
                  Navigator.push(
                      context,MaterialPageRoute(
                      builder: (c)=> const LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  validationForm(){
    if(nameText.text.length< 4){
      Fluttertoast.showToast(msg: "Name must be at least 4 character.");

    }
    else if(!emailText.text.contains("@")){
      Fluttertoast.showToast(msg: "Email Address is not valid.");

    } else if(!emailText.text.contains(".com")){
      Fluttertoast.showToast(msg: "Email Address is not valid.");
    }
    else if(passwordText.text.length<5){
      Fluttertoast.showToast(msg: "Password must be at least 5 character.");
    }
    else if(phoneText.text.isEmpty){
      Fluttertoast.showToast(msg: "Phone number is required.");
    }
    else{
      saveInformation();
    }
  }

  saveInformation() async {
    showDialog(
        context: context, barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Progressing Please wait... ");
        }
    );
    final User? fUser= (


        await firebaseAuthentication.createUserWithEmailAndPassword(

            email: emailText.text.trim(),

            password: passwordText.text.trim()
          // ignore: body_might_complete_normally_catch_error
        ).catchError((msg){

          Navigator.pop(context);

          Fluttertoast.showToast(msg: "Error: $msg");
        })

    ).user;

    if(fUser != null){
      Map driverMap = {
        "id":  fUser.uid,

        "email":  emailText.text.trim(),

        "phone":  phoneText.text.trim(),

        "name":  nameText.text.trim(),

      };
      DatabaseReference driversReference =FirebaseDatabase
          .instance.ref()
          .child("drivers");
      driversReference.child(fUser.uid).set(driverMap);
      currentUser = fUser;

      Fluttertoast.showToast(msg: "Account has been created.");
      Navigator.push(context,
          MaterialPageRoute(
              builder: (c)=> const CarInfoScreen()));
    }
    else{
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Account has not been Created");
    }

  }
}
