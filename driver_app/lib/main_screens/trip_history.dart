import 'package:driver_app/info_handler/app_information.dart';
import 'package:driver_app/main_screens/main_screen.dart';
import 'package:driver_app/main_screens/trip_history_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class TripsHistory extends StatefulWidget {
  const TripsHistory({super.key});

  @override
  State<TripsHistory> createState() => _TripsHistoryState();
}

class _TripsHistoryState extends State<TripsHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Total Trips"),

        leading: IconButton(

          icon:const Icon(Icons.arrow_back),
          onPressed: (){

            Navigator.push(context, MaterialPageRoute(builder: (c) => const MainScreen()));
           Provider.of<AppInformation>(context, listen: false).totalTripHistoryList.clear();
          },
        ),
      ),
      body: ListView.separated(

        itemBuilder: (context, index)
        {
          return Card(
            color: Colors.white54,
            child: TripHistoryWidget(
              totalTripHistory : Provider.of<AppInformation>(context, listen: false).totalTripHistoryList[index],
            ),
          );
        },
        itemCount: Provider.of<AppInformation>(context, listen: false).totalTripHistoryList.length,

        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,

        separatorBuilder: (context, index)=> const Divider(
          color: Colors.grey,
          thickness: 1,
          height: 1,
        ),
      ),

      backgroundColor: Colors.grey,
    );
  }
}
