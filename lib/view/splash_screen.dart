import 'dart:async';
import 'package:elcadi/view/homepage.dart';
import 'package:flutter/material.dart';
import '../core/navigation/navigator_service.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
 late Timer timer;
  @override
  void initState() {
    super.initState();

timer =  Timer(const Duration(seconds: 4,milliseconds: 800),(){


      NavigationService.pushReplacement(const HomePage());});



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar:  AppBar(
    backgroundColor: Colors.black,
actions: [
  TextButton(onPressed: (){
    timer.cancel();
    NavigationService.pushReplacement( const HomePage());


    },  child: const Text("Skip",style: TextStyle(color: Colors.yellow,fontSize: 16),) )
],),
      backgroundColor: Colors.black,
      body: Center(child: Image.asset("assets/splashGif.gif"))


    );
  }
}

