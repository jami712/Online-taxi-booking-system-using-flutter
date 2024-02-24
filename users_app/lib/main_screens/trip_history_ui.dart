import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/models/total_trip_history.dart';

class TripHistoryWidget extends StatefulWidget {

  TripHistoryWidget({super.key, this.totalTripHistory});
  TotalTripHistory? totalTripHistory;

  @override
  State<TripHistoryWidget> createState() => _TripHistoryWidgetState();
}

class _TripHistoryWidgetState extends State<TripHistoryWidget> {

  String formattingDataAndTime(String tripDateTime){

    DateTime dateTime = DateTime.parse(tripDateTime);

    String formattedTime = " ${DateFormat.jm().format(dateTime)},${DateFormat.EEEE().format(dateTime)}, ${DateFormat.MMMd().format(dateTime)} - ${DateFormat.y().format(dateTime)}";
    return formattedTime;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            // total amount
            Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               const Text("Total Trip Amount ",
               style: TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.bold,
                 fontSize: 18,
               ),
               ),
                Text("${widget.totalTripHistory!.totalTripAmount!} ₺",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                ),

              ],
            ),
            const SizedBox(height: 14,),
            //car type
            Row(

              children: [
                const Icon(
                    Icons.directions_car_sharp,
                  color: Colors.white,
                ),
                const SizedBox(width: 15,),
                Text(widget.totalTripHistory!.carType!,
                  style:const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                    fontWeight: FontWeight.bold,
                ),),
              ],
            ),
            const SizedBox(height: 12,),
            // pick up address
            Row(

              children: [
                const Text("Picked From:",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
                ),
                const SizedBox(width: 5,),
                Text("${widget.totalTripHistory!.currentAddress!.substring(0,26)}...",
                  style: const TextStyle(

                    fontSize: 14,
                    color: Colors.white,
                  ),

                ),
              ],
            ),
            const SizedBox(height: 12,),
            // drop off address
            Row(

              children: [
                const Text("Dropped To:",

                  style: TextStyle(
                    fontSize: 14,

                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5,),

                Text(widget.totalTripHistory!.destinationAddress!, overflow:TextOverflow.ellipsis ,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),),
              ],
            ),
            const SizedBox(height: 10,),
            //time
            Text(
                formattingDataAndTime(widget.totalTripHistory!.time!),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
