
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users_app/main.dart';

class TotalAmountDialog extends StatefulWidget {
  double? totalTripAmount;

  TotalAmountDialog({super.key, this.totalTripAmount});

  @override
  State<TotalAmountDialog> createState() => _TotalAmountDialogState();
}

class _TotalAmountDialogState extends State<TotalAmountDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        
      ),
      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.black,

          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(

          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 18),
            Text(
              "Pay Total Amount to Driver".toUpperCase(),

              style: const TextStyle(
                fontSize: 15,
                color: Colors.white54,

                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              thickness: 2,
              color: Colors.grey,

            ),
            const SizedBox(height: 10),

            Text(

              "${widget.totalTripAmount!} ₺ ",

              style: const TextStyle(
                fontSize: 30,

                color: Colors.white54,
                fontWeight: FontWeight.bold,

              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),

              child: ElevatedButton(
                  onPressed: (){
                    collectCash();

                  },
                  child:  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pay Amount",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  collectCash(){
    Future.delayed(const Duration(milliseconds: 2000), (){
      Navigator.pop(context, "AmountPaid");
    });
  }
}
