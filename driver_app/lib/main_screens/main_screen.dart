
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/tab_pages/home_tab.dart';
import 'package:driver_app/tab_pages/profile_tab.dart';
//import 'package:driver_app/tab_pages/rating_tab.dart';
import 'package:driver_app/tab_pages/wallet_tab.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{

  TabController? tabController;
  int selectedIndex = 0;



  @override
  void initState() {
    super.initState();
    tabController = TabController(
        length: 3, vsync: this);
    startStreaming();
  }
  onItemClicked(int index){
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,

        physics: const NeverScrollableScrollPhysics(),

        children:const [
          HomeTabPage(),

          WalletTabPage(),


          ProfileTabPage(),

        ],

      ),
      bottomNavigationBar: BottomNavigationBar(

        items: const [
        BottomNavigationBarItem(

          icon: Icon(Icons.home),
          label: "Home",
        ),

          BottomNavigationBarItem(

            icon: Icon(Icons.credit_card),
            label: "Wallet",
          ),

          BottomNavigationBarItem(

            icon: Icon(Icons.person),
            label: "Account",
          ),
      ],
        backgroundColor: Colors.black,

        unselectedItemColor: Colors.white54,

        selectedItemColor: Colors.lightBlue,

        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
            fontSize: 13),

        onTap: onItemClicked,

        currentIndex: selectedIndex,

      ),
    );
  }

  checkConnection() async{
    result = await Connectivity().checkConnectivity();
    if(result != ConnectivityResult.none){

      isConnected = true;

    } else{
      isConnected = false;
      showDialogBox();


    } setState(() {

    });

  }

  showDialogBox() {
    if (!isDialogBox) {
      isDialogBox = true;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Internet'),
            content: const Text('Please Check Your Internet Connection'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  checkConnection();
                  isDialogBox = false;
                  Fluttertoast.showToast(msg: "Checking Connectivity...");
                },
                child: const Text('Retry'),
              ),
            ],
          );
        },
      );
    }
  }

  startStreaming(){
    subscription = Connectivity().onConnectivityChanged.listen((event) async{
      checkConnection();
    });
  }
}
