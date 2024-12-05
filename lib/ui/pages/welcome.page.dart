import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:fit_planner/ui/pages/gender.page.dart';
import 'package:fit_planner/ui/pages/recipe.page.dart';
import 'package:flutter/material.dart';


class WelcomePage extends StatefulWidget{
  final User ? user;
  const WelcomePage({super.key, required this.user});
  @override
  WelcomeState createState() => WelcomeState(user);
}

class WelcomeState extends State<WelcomePage>{
  WelcomeState(this.user);
  User? user;
  String? userName;

  @override
  void initState() {
    super.initState();
    UserController.getName(user).then((name) {
      setState(() {
        userName = name;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30,right: 30,bottom: 40),
                child: Text('Welcome back to FitPlanner',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF78B500),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(user?.photoURL ?? ''),
                    radius: 50,
                  ),
                  const SizedBox(width: 20.0,),
                  CircleAvatar(
                    foregroundImage: AssetImage("assets/photos/icon.png"),
                    radius: 50,

                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: 30,right: 30,bottom: 40,top: 40),
                  child: Text(userName!,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontFamily: 'SF Pro Display',
                    fontWeight: FontWeight.bold,
                  ),
                  )
              ),
              ElevatedButton(
                onPressed: () async{
                  await UserController.signOut();
                  if(mounted){
                    UserController.user = null;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GenderPage()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF78B500),
                  minimumSize: const Size(200.0, 50.0),
                  shape: RoundedRectangleBorder( // Set border radius
                    borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                  ),
                ), child: Text("Log out",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18.0,
                  fontFamily: 'SF Pro Display',
                ),
              ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () async{
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RecipePage()));
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF78B500),
                  minimumSize: const Size(200.0, 50.0),
                  shape: RoundedRectangleBorder( // Set border radius
                    borderRadius: BorderRadius.circular(50), // Adjust the radius as needed
                  ),
                ), child: Text("Continue",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18.0,
                  fontFamily: 'SF Pro Display',
                ),),
              )
            ]
        ),
      ),
    );
  }
}

