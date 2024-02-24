import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/main_screens/main_screen.dart';
import 'package:users_app/main_screens/user_info_ui.dart';


class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});


  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  // String userName = "Your Name";
  //String userEmail = "Your Email";
  //String phoneNumber = " ";


  //phoneNumber =  userModelCurrentInformation!.phone!;
  //userName = userModelCurrentInformation!.name!;

  //userEmail = userModelCurrentInformation!.email!;
  //print("haha: $userName");


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,
        title: const Text("Go to Main Page"),
        leading: IconButton(

          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => const MainScreen()));
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // user name
            Text(
              userName,

              style: const TextStyle(

                fontWeight: FontWeight.bold,
                fontSize: 30,

                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20, width: 30,),
            Text(
             "Your ratings: $yourRatings",

              style: const TextStyle(

                fontWeight: FontWeight.bold,
                fontSize: 20,

                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20, width: 30,),

            const Divider(

              color: Colors.white10,
              height: 4,
              thickness: 4,
            ),
            //Phone
            UserInfoUi(

              info: phone,
              iconData: Icons.phone_android,
            ),

            //Email
            UserInfoUi(
              info: userEmail,
              iconData: Icons.email_outlined,
            ),
            ElevatedButton(
              onPressed: () {
                showDeleteConfirmationDialog(context);


              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                "Delete Account",
              ),
            ),
          ],
        ),

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
                FirebaseDatabase.instance.ref().child("users").child(currentFirebaseUser!.uid).remove();
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
}
