import 'package:flutter/material.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/main_screens/predicted_place.dart';
import 'package:users_app/models/autocomplete_places.dart';


class SearchPlaces extends StatefulWidget {
  const SearchPlaces({super.key});

  @override
  State<SearchPlaces> createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {

  List<AutoCompletePlaces> placesList = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,

      body: Column(

        children: [
          // Search Place ui
          const SizedBox(height: 10,),
          Container(
            height: 150,
            decoration: const BoxDecoration(

              boxShadow:[
              BoxShadow(
                color: Colors.white54,
                blurRadius: 7,

                spreadRadius: 0.5,
                offset: Offset(0.7,0.7),
              ),
             ],

              color: Colors.black,
            ),

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 24.0,),

                  Stack(
                    children: [

                      GestureDetector(
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white30,

                        ),
                        onTap:(){
                          Navigator.pop(context);
                        },

                      ),
                      const Center(
                        child: Text(
                          "Search your destination",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white30,
                      ),
                      const SizedBox(width: 17),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value){

                              searchPlaces(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Search Here.",
                              fillColor: Colors.white54,

                              border: InputBorder.none,
                                filled: true,
                              contentPadding: EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                                left: 11.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Display Suggested Places
            if ( placesList.isNotEmpty)  Expanded(
                 child: ListView.separated(
                   itemCount: placesList.length,
                   physics: const ClampingScrollPhysics(),
                   itemBuilder: (context, index){
                     return Container(
                       child: PlacePredictionTileDesign(
                         predictedPlaces: placesList[index],
                       ),
                     );
                   },
                   separatorBuilder: (BuildContext context, int index){
                     return const Divider(
                       height: 1,
                       thickness: 1,
                       color: Colors.grey,
                     );
                   },
                 ),
            ) else Container(),
        ],
      ),
    );
  }

  void searchPlaces(String searchText) async{
    try{
    if(searchText.isNotEmpty){
      String googleUrlAutoComplete = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchText&key=$mapKey&components=country:CY";

      var response = await RequestAssistant.receivedRequest(googleUrlAutoComplete);

      if(response == "Failed, try again..."){

        return;
      }
      if(response["status"] =="OK"){

        var placePrediction = response["predictions"];
        if(placePrediction != null && placePrediction is List){
          var placePredictionList = placePrediction.map((jsonData) => AutoCompletePlaces.fromJson(jsonData)).toList();

          setState(() {

            placesList = placePredictionList;
          });
        }

       // var placePredictionList = (placePrediction as List).map((jsonData) => AutoCompletePlaces.fromJson(jsonData)).toList();


      }
    }
  }catch(e){
    print("Error while searching places: $e");
    }
  }

}


