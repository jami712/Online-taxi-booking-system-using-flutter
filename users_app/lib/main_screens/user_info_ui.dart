import 'package:flutter/material.dart';

class UserInfoUi extends StatefulWidget {


  UserInfoUi({super.key, this.iconData, this.info});


  String? info;
  IconData? iconData;

  @override
  State<UserInfoUi> createState() => _UserInfoUiState();
}

class _UserInfoUiState extends State<UserInfoUi> {
  @override
  Widget build(BuildContext context) {

    return Card(
      margin:const  EdgeInsets.symmetric(horizontal: 22, vertical: 16),

      color: Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        leading: Icon(widget.iconData, color: Colors.black,),

        title: Text(widget.info!,
          style: const TextStyle(

            color: Colors.black,
            fontWeight: FontWeight.bold,

            fontSize: 18,
          ),
        ),

      ),
    );
  }
}
