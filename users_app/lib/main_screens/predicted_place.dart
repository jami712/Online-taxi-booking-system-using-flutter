import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/info_handler/app_information.dart';
import 'package:users_app/main_screens/progress_dialog.dart';
import 'package:users_app/models/directions.dart';

import '../models/autocomplete_places.dart';

class PlacePredictionTileDesign extends StatefulWidget {


  final AutoCompletePlaces? predictedPlaces;

  const PlacePredictionTileDesign({super.key, this.predictedPlaces});

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed:(){
          try {
            final placeId = widget.predictedPlaces?.place_id;
            if(placeId != null ){
              getPlaceDetailsAndSetDropOff(placeId, context);
            }else{
              throw Exception("Place Id is null");
            } /*
            getPlaceDetailsAndSetDropOff(

                widget.predictedPlaces!.place_id!, context);
                */
          }

          catch(e){
            print("Error getting place: $e");
            ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
                  content : Text("Error getting place details. please try again."),
                backgroundColor: Colors.red,
                ),
            );
          }
        },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white30,
      ),
      child: Padding(

        padding: const EdgeInsets.all(5.0),
        child: Row(

        children: [
          const Icon(
            Icons.add_location,
            color: Colors.grey,

          ),
          const SizedBox(width: 14.0,),

          Expanded(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 7.0,),
                Text(
                  widget.predictedPlaces!.main_text!,

                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(

                    color: Colors.white54,
                    fontSize: 16.0,
                  ),

                ),
                const SizedBox(height: 2.0,),
                Text(

                  widget.predictedPlaces!.secondary_text!,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13.0,
                  ),

                ),
                const SizedBox(height: 8.0,),

              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  getPlaceDetailsAndSetDropOff(String? placeId, context) async {

    try{
    showDialog(
        context: context,
        builder:(BuildContext context) => Padding(
          padding: const EdgeInsets.all(6.0),
          child: ProgressDialog(
            message: "Fetching Location, \n Please Wait..",
          ),
        )
    );
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var googleApiResponse = await RequestAssistant.receivedRequest(placeDetailsUrl);

    Navigator.pop(context);

    if(googleApiResponse == "Failed, try again..."){

      return;
    }
    if(googleApiResponse["status"] == "OK" ){

      Directions userDropOffLocation = Directions(
          locationName : googleApiResponse["result"]["name"],

          locationLongitude : googleApiResponse["result"]["geometry"]["location"]["lng"],

          locationLatitude : googleApiResponse["result"]["geometry"]["location"]["lat"],

          locationId : placeId,
      );




      Provider.of<AppInformation>(context, listen: false).updateUserDrpOffLocation(userDropOffLocation);

      setState(() {
        userDestination = userDropOffLocation.locationName!;
      });
      Navigator.pop(
          context, "GotLocation");
    }

  }catch(e){
    print("Error while sitting location: $e");
    }
  }
}
