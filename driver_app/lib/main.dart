
import 'package:driver_app/info_handler/app_information.dart';
import 'package:driver_app/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(
      child: ChangeNotifierProvider(

        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          title: 'Driver App',
          home:const SplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
        create: (context) => AppInformation(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget
{
  final Widget? child;
  const MyApp({super.key, this.child});

  static void restartApp(BuildContext context)
  {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Key uniqueKey = UniqueKey();

  void restartApp()
  {
    setState(() {
      uniqueKey = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key:uniqueKey,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: widget.child,
      ),
    );
  }
}


