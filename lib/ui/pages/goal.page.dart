import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'age.page.dart';

class GoalPage extends StatefulWidget{
  final User ? user;
  final int g;
  final String name;

  const GoalPage({super.key, required this.user, required this.g, required this.name});
  @override
  GoalState createState() => GoalState(user,g,name);
}

class GoalState extends State<GoalPage> {
  GoalState(this.user, this.g,this.name);
  User ? user;
  int g;
  String name;

  int selectedIndex = -1;

  void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


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
                      Expanded(child:
                      TweenAnimationBuilder<double>(
                        tween: Tween(
                            begin: 0,
                            end: 5
                        ),
                        duration: const Duration(milliseconds: 500),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: const SizedBox(
                              height: 10.0,
                              child: LinearProgressIndicator(
                                value: 0.5,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [ Text('Welcome $name what\'s your goal ?',
                style: TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
                Text('And we will provide the best programs for you!',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5F5F5F)
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50.0,
            ),
            ButtonGroup(
              onSelect: updateSelectedIndex,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (ImageButtonGroupState.selectedIndex != -1) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => AgePage(user: user,g: g,name: name,goal: selectedIndex,),
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
                backgroundColor: Color(ImageButtonGroupState.selectedIndex == -1 ? 0xFFB9D777 : 0xFF78B500),
                minimumSize: const Size(300.0, 70.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                10),
                ),
              ),
              child:
              Text('Next',
                style: TextStyle(
                  color: Color(ImageButtonGroupState.selectedIndex == -1 ? 0xFFDCEBBB : 0xFFFFFFFF),
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

class ButtonGroup extends StatefulWidget {
  final Function(int) onSelect;

  const ButtonGroup({super.key, required this.onSelect});

  @override
  ImageButtonGroupState createState() => ImageButtonGroupState();
}

class ImageButtonGroupState extends State<ButtonGroup> {
 static int selectedIndex = -1;
  void handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onSelect(index);
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: ()=> handleTap(1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              padding: EdgeInsets.only(left: 16.0,top: 10.0,right: 16.0,bottom: 10.0),
              decoration: BoxDecoration(
                border: selectedIndex == 1 ? Border.all(
                  color: Colors.black,
                  width: 2.0
                ):Border(),
                color: Color(0xFFF9FAEE),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/photos/flexedBiceps.png',
                    width: 40.0,
                    height: 40.0,
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gain muscle',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      Visibility(
                        visible: selectedIndex == 1,
                        child: const Text('Focus on muscle mass and \nsize groth'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.0),
          GestureDetector(
            onTap: ()=> handleTap(2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              padding: EdgeInsets.only(left: 16.0,top: 10.0,right: 16.0,bottom: 10.0),
              decoration: BoxDecoration(
                border: selectedIndex == 2 ? Border.all(
                    color: Colors.black,
                    width: 2.0
                ):Border(),
                color: Color(0xFFF9FAEE),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset('assets/photos/fire.png',
                    width: 40.0,
                    height: 40.0,
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Weight Loss',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      Visibility(
                        visible: selectedIndex == 2,
                        child: const Text('Focus on creating a calorie deficit \nto reduce overall body weight'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.0),
          GestureDetector(
            onTap: ()=> handleTap(3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              padding: EdgeInsets.only(left: 16.0,top: 10.0,right: 16.0,bottom: 10.0),
              decoration: BoxDecoration(
                border: selectedIndex == 3 ? Border.all(
                    color: Colors.black,
                    width: 2.0
                ):Border(),
                color: Color(0xFFF9FAEE),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 5, // Spread radius of the shadow
                    blurRadius: 7, // Blur radius of the shadow
                    offset: Offset(0, 3), // Offset for the shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset('assets/photos/battery.png',
                    width: 40.0,
                    height: 40.0,
                  ),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Improved Endurance',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      Visibility(
                        visible: selectedIndex == 3,
                        child: const Text('Focus on increasing stamina \nand cardiovascular fitness'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]
    );
  }
}

