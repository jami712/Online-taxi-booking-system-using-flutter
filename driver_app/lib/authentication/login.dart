import 'package:driver_app/authentication/sign_up.dart';
import 'package:driver_app/main_screens/forgotten_password.dart';
import 'package:driver_app/main_screens/progress_dialog.dart';
import 'package:driver_app/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
           children: [
            const SizedBox(height: 32,),
            Padding(

             padding:const EdgeInsets.all(20.0),

              child:  Image.asset("images/logo.png"),
            ),
             const SizedBox(height: 9,),

             const Text(
               "Login as a Driver",
               style: TextStyle(
                 color: Colors.grey,
                 fontWeight: FontWeight.bold,
                 fontSize: 24,
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
               controller: passwordText,
               keyboardType: TextInputType.text,
               obscureText: true,

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
             const SizedBox(height: 18,),

             ElevatedButton(

               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.lightGreen,
               ),
               child: const Text(
                 "Login",
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 17,
                 ),
               ),

               onPressed: (){
                 validationForm();
               },
             ),
           Column(
             children: [
               TextButton(
                child: const Text(
                  "Do not have an account? SignUp here.",
                  style: TextStyle(
                      color: Colors.white24
                  ),
                ) ,
                 onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(
                      builder: (c)=>const SignUpScreen()));
                 },
          ),
               const SizedBox(height: 10,),
               TextButton(
                 child: const Text(
                   "Forgot Password?",
                   style: TextStyle(
                       color: Colors.white24
                   ),
                 ) ,
                 onPressed: (){
                   Navigator.push(
                       context, MaterialPageRoute(
                       builder: (c)=>const ForgotPasswordScreen()));
                 },
               ),
             ],
           ),
           ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
  login() async {
    showDialog(
        context: context, barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Progressing Please wait... ");
        }
    );
    final User? fUser= (
        await firebaseAuthentication.signInWithEmailAndPassword(
            email: emailText.text.trim(),
            password: passwordText.text.trim()
          // ignore: body_might_complete_normally_catch_error
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: $msg");
        })

    ).user;

    if(fUser != null){
      DatabaseReference driversReference =FirebaseDatabase
          .instance.ref()
          .child("drivers");
      driversReference
          .child(fUser.uid).once().then((driverKey){

        final snap = driverKey.snapshot;

        if(snap.value != null){

          currentUser = fUser;

          Fluttertoast.showToast(msg: "Logged in.");
          // ignore: use_build_context_synchronously
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const SplashScreen()));
        }
        else{
          Fluttertoast.showToast(msg: "No Record exist with this email.");
          firebaseAuthentication.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const SplashScreen()));
        }

      });


    }
    else{
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Not Logged in");
    }

  }


  validationForm(){


    if(!emailText.text.contains("@")){
      Fluttertoast.showToast(msg: "Email Address is not valid.");

    } else if(!emailText.text.contains(".com")){
      Fluttertoast.showToast(msg: "Email Address is not valid.");
    }

    else if(passwordText.text.isEmpty){
      Fluttertoast.showToast(msg: "Password is required.");
    }
    else{
      login();
    }
  }

}
