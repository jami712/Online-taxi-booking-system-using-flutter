import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:users_app/info_handler/app_information.dart';
import 'package:users_app/main_screens/main_screen.dart';
import 'package:users_app/main_screens/trip_history_ui.dart';


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
        backgroundColor: Colors.transparent,
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
      backgroundColor: Colors.grey,

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
    );
  }
}
