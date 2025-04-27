import 'dart:async';
import 'package:elcadi/core/navigation/navigator_service.dart';
import 'package:elcadi/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif/gif.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Centered GIF/Image
          Center(
            child: SizedBox(
              child: Gif(
                autostart: Autostart.once,

                onFetchCompleted: () {
                  // Navigate to HomePage after the GIF completes
                  Timer(const Duration(seconds: 6), () {
                    NavigationService.pushReplacement(const HomePage());
                  });
                },
                controller: _gifController,
                image: const AssetImage("assets/splashGif.gif"),
                fit:
                    BoxFit
                        .contain, // Ensures the GIF fits within the box without distortion
              ),
            ),
          ),

          // Skip Button (Positioned at the Top-Right Corner)
          Positioned(
            top:
                MediaQuery.of(context).padding.top +
                16, // Adjust for status bar
            right: 16,
            child: TextButton(
              onPressed: () {
                NavigationService.pushReplacement(const HomePage());
              },
              child: const Text(
                "Skip",
                style: TextStyle(color: Colors.yellow, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
