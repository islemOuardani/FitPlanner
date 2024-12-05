import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:fit_planner/ui/pages/signup.page.dart';
import 'package:flutter/material.dart';
import 'package:ruler_slider/ruler_slider.dart';

import 'welcome.page.dart';

class WeightPage extends StatefulWidget {

  final User ? user;
  final int g;
  final String name;
  final int goal;
  final int age;
  final double height;
  const WeightPage({super.key, required this.user, required this.g, required this.name, required this.goal, required this.age, required this.height});

  @override
  _WeightPageState createState() => _WeightPageState(user, g, name, goal, age, height);
}

class _WeightPageState extends State<WeightPage> {
  _WeightPageState(this.user, this.g,this.name, this.goal, this.age, this.height);
  User ? user;
  int g;
  String name;
  int goal;
  int age;
  double height;

  double _currentWeightValue = 30;
  double _currentLbs = 66;
  double _ibm = 18;
  bool isKg = true;


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
                              value: 1,
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
                  'Please select your weight',
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
                  isSelected: [isKg, !isKg],
                  onPressed: (index) {
                    setState(() {
                      isKg = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  selectedColor: Colors.white,
                  fillColor: Color(0xff78B500),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('kg'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('lbs'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:  isKg ? _currentWeightValue.toStringAsFixed(2) : _currentLbs.toStringAsFixed(2) ,
                        style: TextStyle(
                          fontSize: 40.0,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: isKg ? ' kg' : ' lbs',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                RulerSlider(
                  minValue: 0.0,
                  maxValue: 220.0,
                  rulerHeight: 150.0,
                  selectedBarColor: Color(0xff78B500),
                  unselectedBarColor: Color(0xffc6c6c6),
                  tickSpacing: 40.0,
                  valueTextStyle: TextStyle(color: Colors.red, fontSize: 18),
                  onChanged: (double value) {
                    setState(() {
                      _currentWeightValue = 30 + value;
                      _ibm = _currentWeightValue / ((height/100)*(height/100));
                      if(!isKg){
                        _currentLbs = _currentWeightValue * 2.2046226219 ;
                      }
                    });
                  },
                  showFixedBar: true,
                  fixedBarColor: Color(0xff387800),
                  fixedBarWidth: 5.0,
                  fixedBarHeight: 80.0,
                  showFixedLabel: false,
                  scrollSensitivity: 2,
                  enableSnapping: false,
                  majorTickInterval: 5,
                  labelInterval: 1,
                  labelVerticalOffset: 50.0,
                  showBottomLabels: false,
                  majorTickHeight: 20.0,
                  minorTickHeight: 10.0,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xffCACAC7),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR CURRENT BMI',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        _ibm.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 40,
                            color: _ibm < 18 ? Colors.red
                                : _ibm < 25 ? Colors.green :
                                _ibm < 30 ? Colors.orange :
                                    Colors.red
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                          _ibm < 18 ? 'Your BMI is below the healthy \nrange. It\'s important to focus \non a balanced diet and \nseek advice from a \nhealthcare professional \nto ensure you\'re meeting \nyour nutritional needs.' :
                          _ibm < 25 ? 'Your BMI is within the \nhealthy range. \nKeep up the good work by \nmaintaining a balanced \ndiet and regular exercise \nto stay healthy and active.' :
                          _ibm < 30 ?' Your BMI is in the overweight \nrange. It\'s a good time to \nconsider healthy lifestyle \nchanges, including a balanced \ndiet and regular physical \nactivity, to help achieve and \nmaintain a healthier weight.' :
                          'Your BMI is in the \nobese range. \nIt\'s important to consider \ndietary changes, exercise, \nand lifestyle adjustments.',
                        style: TextStyle(
                          fontSize: 12
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if(user != null){
                  UserController.saveUser(user, g, name, goal, age, height, _currentWeightValue);
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => WelcomePage(user: user,),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => SignupPage(user: user, name: name, g: g, goal: goal, age: age, height: height, weight: _currentWeightValue,),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF78B500),
                minimumSize: const Size(300.0, 70.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10),
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
