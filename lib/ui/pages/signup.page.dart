import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:fit_planner/ui/pages/welcome.page.dart';
import 'package:flutter/material.dart';


class SignupPage extends StatefulWidget{

  final User ? user;
  final int g;
  final String name;
  final int goal;
  final int age;
  final double height;
  final double weight;

  const SignupPage({super.key, required this.user, required this.g, required this.name, required this.goal, required this.age, required this.height, required this.weight});

  @override
  SignupState createState() => SignupState(user,g,name,goal,age,height,weight);
}

class SignupState extends State<SignupPage>{
  SignupState(this.user, this.g,this.name, this.goal, this.age, this.height, this.weight);
  User ? user;
  int g;
  String name;
  int goal;
  int age;
  double height;
  double weight;

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final TextEditingController mailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();
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
            Text('We\'re almost there, just enter your email and a password. ',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding:EdgeInsets.only(left: 30.0,top: 9.0,right: 35.0,bottom: 50.0),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Champ e-mail
                            TextFormField(
                              controller: mailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Mail',
                                hintText: 'exemple@mail.com',
                                labelStyle: TextStyle(fontSize: 25.0),
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                              ),
                              style: const TextStyle(fontSize: 20.0),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer une adresse e-mail';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Adresse e-mail invalide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10.0),

                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(fontSize: 25.0),
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                              ),
                              style: const TextStyle(fontSize: 20.0),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un mot de passe';
                                }
                                if (value.length < 8) {
                                  return 'Le mot de passe doit contenir au moins 8 caractères';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10.0),

                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(fontSize: 25.0),
                                border: UnderlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
                              ),
                              style: const TextStyle(fontSize: 20.0),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez confirmer votre mot de passe';
                                }
                                if (value != passwordController.text) {
                                  return 'Les mots de passe ne correspondent pas';
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async{
                                if(_formKey.currentState!.validate()) {
                                user = await UserController.registerWithEmailPassword(mailController.text, passwordController.text);
                                if(user != null){
                                  UserController.saveUser(user, g, name, goal, age,height, weight);
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
                                }
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}