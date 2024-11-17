import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:fit_planner/ui/pages/welcome.page.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TextEditingController mailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30), // Back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                foregroundImage: AssetImage('assets/photos/icon2.png'),
                radius: 50.0,
              ),
              Padding(padding:EdgeInsets.only(left: 50.0,top: 20.0,right: 50.0,bottom: 50.0),
                  child:
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: mailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Mail',
                            labelStyle: TextStyle(fontSize: 20.0),
                            border: UnderlineInputBorder(),
                          ),
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
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 20.0),
                            border: UnderlineInputBorder(),
                          ),
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
                        const SizedBox(height: 10,),
                        Builder(
                          builder: (context) {
                            final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
                            return Visibility(
                              visible: !keyboardVisible, // Hide button if keyboard is visible
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final user = await UserController.loginWithEmailPassword(mailController.text,passwordController.text);
                                      if (user != null ) {
                                        await UserController.userExists(user);
                                        if (mounted){
                                          Navigator.pop(context);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(builder: (context) => const WelcomePage())
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("The login or password is incorrect."),
                                            duration: Duration(seconds: 5), // Optional: control display duration
                                          ),
                                        );
                                      }
                                    } on FirebaseAuthException catch (error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error.message ?? "Something went wrong"),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(error.toString()),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF78B500),
                                  minimumSize: const Size(250.0, 60.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Log in',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 24.0,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
              ),
            ]
        ),
      ),
    );
  }
}

