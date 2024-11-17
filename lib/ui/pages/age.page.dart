import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruler_slider/ruler_slider.dart';

import 'height.page.dart';
import 'welcome.page.dart';

class AgePage extends StatefulWidget {

  final User ? user;
  final int g;
  final String name;
  final int goal;
  const AgePage({super.key, required this.user, required this.g, required this.name, required this.goal});

  @override
  _AgePageState createState() => _AgePageState(user,g,name,goal);
}

class _AgePageState extends State<AgePage> {
  _AgePageState(this.user, this.g,this.name, this.goal);
  User ? user;
  int g;
  String name;
  int goal;

  TextEditingController ageController = TextEditingController();
  int age = 18;

  bool conf = false ;
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
                padding:  const EdgeInsets.symmetric(vertical: 0.0),
                child: Row (
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 30), // Back icon
                        onPressed: () {
                          Navigator.pop(context); // Navigate back to the previous screen
                        },
                      ),
                      const SizedBox(width: 32.0),
                      Expanded(child:
                      TweenAnimationBuilder<double>(
                        tween: Tween(
                            begin: 0,
                            end: 5
                        ),
                        duration: const Duration(milliseconds: 500),
                        builder: (BuildContext context, double value, Widget? child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: const SizedBox(
                              height: 10.0,
                              child: LinearProgressIndicator(
                                value: 0.666,
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
                    ]
                )
            ),
            const SizedBox(
              height: 32.0,
            ),
            Text('What\'s your age ?',
              style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            const SizedBox(
              height: 120.0,
            ),
            TextField(
              controller: ageController,
              onChanged: (String name) {
                setState(() {
                  conf = (name != '');
                });},
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                labelText: 'Age',
                labelStyle: TextStyle(
                  fontSize: 25.0,
                ),
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.symmetric( horizontal: 30.0), // Padding
              ),
              style: const TextStyle(
                fontSize: 35.0,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: (){
                if(conf == true){
                  age = int.tryParse(ageController.text)!;
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HeightPage(user: user, g: g, name: name, age: age, goal: goal,),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation, // Use the animation to control opacity (fade effect)
                          child: child,
                        );
                      },
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(conf == true ? 0xFF78B500 : 0xFFB9D777),
                minimumSize: const Size(300.0, 70.0),
                shape: RoundedRectangleBorder( // Set border radius
                  borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                ),
              ),
              child:
              Text('Next',
                style: TextStyle(
                  color: Color(conf == true ?0xFFFFFFFF : 0xFFDCEBBB),
                  fontSize: 24.0,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
