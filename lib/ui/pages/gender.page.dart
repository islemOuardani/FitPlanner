import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:fit_planner/ui/pages/welcome.page.dart';
import 'package:flutter/material.dart';

import 'login.page.dart';
import 'name.page.dart';

class GenderPage extends StatefulWidget{
  const GenderPage({super.key});
  @override
  GenderState createState() => GenderState();
}

class GenderState extends State<GenderPage>{
  static int g = 1;
  static User ? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
            child: TweenAnimationBuilder<double>(
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
                      value: 0.166,
                      backgroundColor: Color(0xffc6c6c6),
                      color: Color(0xff78B500),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          const Text('What\'s your gender ?',
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageButtonGroup(),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: (){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NamePage(user: GenderState.user,g: ImageButtonGroupState.selectedIndex,),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF78B500),
              minimumSize: const Size(300.0, 70.0),
              shape: RoundedRectangleBorder( // Set border radius
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
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
          const SizedBox(
            height: 20.0,
          ),
          if (user == null) ...[
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1, // Line height
                    color: Colors.grey, // Line color
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0), // Space around the text
                  child: Text(
                    'Already our member ?',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ),

                Expanded(
                  child: Container(
                    height: 1, // Line height
                    color: Colors.grey, // Line color
                  ),
                ),
              ],
            ),
            TextButton(
                onPressed: (){
                  showAuthOptions(context);
                },
                child: const Text('Continue with your existing account >',
                  style: TextStyle(
                      fontSize: 16.0
                  ),
                )
            ),
          ],
        ],
      ),
      ),
    );
  }

  void updateUser(User newUser) {
    setState(() {
      user = newUser;  // Update user
    });
  }

  void showAuthOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(right: 16.0,left: 16.0,top:20.0,bottom: 20.0),
          height: 250, // Set the height of the bottom sheet
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async{
                  final user = await UserController.signInWithFacebook();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Color(0xff1877F2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.facebook,
                    color: Colors.white,
                    ),
                    SizedBox(width: 20.0,),
                    Text('Continue with Facebook',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final user = await UserController.loginWithGoogle();

                    if (user != null ) {
                      if(await UserController.userExists(user) == 1){
                        if (mounted){
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const WelcomePage())
                          );
                        }
                      }else if (await UserController.userExists(user) == 0){
                        updateUser(user);
                        Navigator.pop(context);
                      }
                    }
                  } on FirebaseAuthException catch (error) {
                    print(error);
                  } catch (error) {
                    print(error);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:  Colors.red, // Google color
                ),
                child: Row(
                  children: [
                    Image.asset("assets/photos/google.png",
                      width: 20,
                    ),
                    SizedBox(width: 20.0,),
                    Text('Continue with Google',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginPage())
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.mail,
                      color: Color(0xFF78B500),
                    ),
                    SizedBox(width: 20.0,),
                    Text('Continue with FP account',
                      style: TextStyle(
                          color: Color(0xFF78B500),
                          fontSize: 18.0
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ImageButtonGroup extends StatefulWidget {
  const ImageButtonGroup({super.key});
  @override
  ImageButtonGroupState createState() => ImageButtonGroupState();
}

class ImageButtonGroupState extends State<ImageButtonGroup> {
  static int selectedIndex = 0;

  void onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.linear,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              selectedIndex == 0
                  ? 'assets/photos/backMale.png'
                  : 'assets/photos/backFemale.png'
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => onSelect(0),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: selectedIndex == 0 ? 212 : 140,
                height: selectedIndex == 0 ? 300 : 225,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    selectedIndex == 0
                        ? 'assets/photos/maleGenderSelected.png'
                        : 'assets/photos/maleGender.png',
                    key: ValueKey(selectedIndex == 0),
                  ),
                )
            ),
          ),
          //const SizedBox(width: 20),
          GestureDetector(
            onTap: () => onSelect(1),
            child:  AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: selectedIndex == 1 ? 212 : 140,
                height: selectedIndex == 1 ? 300 : 225,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    selectedIndex == 1
                        ? 'assets/photos/femaleGenderSelected.png'
                        : 'assets/photos/femaleGender.png',
                    key: ValueKey(selectedIndex == 1),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}