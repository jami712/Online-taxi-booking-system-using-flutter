import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {


  ProgressDialog({super.key, this.message});
     String? message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black54,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(

          padding: const EdgeInsets.all(15),
          child: Row(
            children: [

              const SizedBox(width: 6.0, height: 4,),
              const CircularProgressIndicator(

               valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                 ),
            const SizedBox(width: 25.0,),

              Expanded(
                child: Text(
                  message!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
