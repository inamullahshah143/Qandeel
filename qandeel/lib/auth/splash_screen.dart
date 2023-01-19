import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qandeel/constants/colors.dart';
import 'package:qandeel/home/home.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () async {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: HomeScreen(),
          isIos: true,
          duration: const Duration(milliseconds: 1500),
        ),
      );
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset(
                    'assets/images/app_logo1.png',
                    fit: BoxFit.fill,
                  ).image,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/govt_logo.png',
                      fit: BoxFit.fill,
                    ).image,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: MediaQuery.of(context).size.width * 0.3,
                color: AppColor.blackColor,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.fill,
                    ).image,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
