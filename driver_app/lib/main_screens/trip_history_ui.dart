import 'package:driver_app/models/total_trip_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TripHistoryWidget extends StatefulWidget {

  TripHistoryWidget({super.key, this.totalTripHistory});

  TotalTripHistory? totalTripHistory;

  @override

  State<TripHistoryWidget> createState() => _TripHistoryWidgetState();
}

class _TripHistoryWidgetState extends State<TripHistoryWidget> {

  String formattingDataAndTime(String tripDateTime){

    DateTime dateTime = DateTime.parse(tripDateTime);

    // Example: Format as "6:30 PM,Friday ,Dec 1 - 2024"

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
                Text(
                  "${widget.totalTripHistory!.totalTripAmount!} ₺",
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

                Text("${widget.totalTripHistory!.currentAddress!.substring(0,25)}...",
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
                Text(widget.totalTripHistory!.destinationAddress!,overflow:TextOverflow.ellipsis,
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
