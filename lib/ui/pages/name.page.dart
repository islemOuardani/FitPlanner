import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'goal.page.dart';

class NamePage extends StatefulWidget{
  final User ? user;
  final int g;

  const NamePage({super.key, required this.user, required this.g});
  @override
  NameState createState() => NameState(user,g);
}

class NameState extends State<NamePage>{
  NameState(this.user, this.g);
  User ? user;
  int g;
  String get username => user?.displayName ?? "";
  bool conf = false;
  String name='';
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = username;
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
                              value: 0.333,
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
            Text('What\'s your name ?',
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
              controller: nameController,
              onChanged: (String name) {
                setState(() {
                  conf = (name != '');
                });},
              decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontSize: 25.0,
                  ),
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric( horizontal: 30.0),
              ),
              style: const TextStyle(
                fontSize: 35.0,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: (){
                if(conf == true){
                  name = nameController.text;
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => GoalPage(user: user, g: g, name: name,),
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