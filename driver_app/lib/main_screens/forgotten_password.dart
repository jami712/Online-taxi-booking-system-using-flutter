import 'package:driver_app/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(

          icon:const Icon(Icons.arrow_back),
          onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));

          },
        ),
        title: const Text('Forgot Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32,),
            Padding(

              padding:const EdgeInsets.all(20.0),

              child:  Image.asset("images/logo.png"),
            ),
            const SizedBox(height: 9,),
            const Text(
              "Reset Your Password Here",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
                  TextField(
                    style: const TextStyle(
                      color: Colors.grey,

                    ),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Enter your email',
                      hintText: 'Enter your email',

                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),

                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),

                      ),

                      hintStyle: TextStyle(
                        color:  Colors.grey,
                        fontSize: 11,
                      ),
                      labelStyle: TextStyle(
                        color:  Colors.grey,
                        fontSize: 18,

                    ),
                  ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                    ),
                    onPressed: () {
                      resetPassword();
                    },
                    child: const Text('Reset Password'),
                  ),
                ],
              ),
      ),
          );


  }
  Future<void> resetPassword() async {
    String email = _emailController.text;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Password reset email sent successfully
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset'),
            content: Text('A password reset email has been sent to $email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Handle errors here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to send password reset email. Please check the email address and try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:const Text('OK'),
              ),
            ],
          );
        },
      );
      print(error.toString());
    }
  }
}
