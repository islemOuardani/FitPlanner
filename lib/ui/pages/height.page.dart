import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ruler_slider/ruler_slider.dart';

import 'weight.page.dart';

class HeightPage extends StatefulWidget {

  final User ? user;
  final int g;
  final String name;
  final int goal;
  final int age;
  const HeightPage({super.key, required this.user, required this.g, required this.name, required this.goal, required this.age});

  @override
  _HeightPageState createState() => _HeightPageState(user, g, name, goal, age);
}

class _HeightPageState extends State<HeightPage> {

  _HeightPageState(this.user, this.g,this.name, this.goal, this.age);
  User ? user;
  int g;
  String name;
  int goal;
  int age;

  double _currentHeightValue = 100;
  double _currentInches = 0;
  double _currentFeet = 0;
  bool isCm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 32.0),
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 5),
                      duration: const Duration(milliseconds: 500),
                      builder: (BuildContext context, double value, Widget? child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: const SizedBox(
                            height: 10.0,
                            child: LinearProgressIndicator(
                              value: 0.833,
                              backgroundColor: Color(0xffc6c6c6),
                              color: Color(0xff78B500),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 80.0,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Please select your height',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ToggleButtons(
                  isSelected: [isCm, !isCm],
                  onPressed: (index) {
                    setState(() {
                      isCm = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  selectedColor: Colors.white,
                  fillColor: Color(0xff78B500),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('cm'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('inches'),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:  isCm ? _currentHeightValue.toStringAsFixed(2) : '${_currentFeet.toStringAsFixed(0)}\' ${_currentInches.toStringAsFixed(0)}\'\'' ,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: isCm ? ' cm' : '',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: RulerSlider(
                    minValue: 0.0,
                    maxValue: 15.0,
                    rulerHeight: 150.0,
                    selectedBarColor: Color(0xff78B500),
                    unselectedBarColor: Color(0xffc6c6c6),
                    tickSpacing: 40.0,
                    valueTextStyle: TextStyle(color: Colors.red, fontSize: 18),
                    onChanged: (double value) {
                      setState(() {
                        _currentHeightValue = 100 + (10 * value);
                        if(!isCm){
                          _currentInches = _currentHeightValue * 0.393701 ;
                          _currentFeet =  _currentInches / 12.0  ;
                          _currentInches = _currentInches % 12;
                        }
                      });
                    },
                    showFixedBar: true,
                    fixedBarColor: Color(0xff387800),
                    fixedBarWidth: 5.0,
                    fixedBarHeight: 80.0,
                    showFixedLabel: false,
                    scrollSensitivity: 1,
                    enableSnapping: false,
                    majorTickInterval: 5,
                    labelInterval: 1,
                    labelVerticalOffset: 50.0,
                    showBottomLabels: false,
                    majorTickHeight: 20.0,
                    minorTickHeight: 10.0,
                  ),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => WeightPage(user: user, g: g, name: name,goal: goal, age: age, height: _currentHeightValue,),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation, // Use the animation to control opacity (fade effect)
                      child: child,
                    );
                  },
                ),
              );},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF78B500),
                minimumSize: const Size(300.0, 70.0),
                shape: RoundedRectangleBorder( // Set border radius
                  borderRadius: BorderRadius.circular(
                      10), // Adjust the radius as needed
                ),
              ),
              child:
              const Text('Next',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 24.0,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
