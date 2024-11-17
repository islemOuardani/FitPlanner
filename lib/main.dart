import 'package:firebase_core/firebase_core.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:fit_planner/firebase_options.dart';
import 'package:fit_planner/ui/pages/age.page.dart';
import 'package:fit_planner/ui/pages/height.page.dart';
import 'package:fit_planner/ui/pages/login.page.dart';
import 'package:fit_planner/ui/pages/recipe.page.dart';
import 'package:fit_planner/ui/pages/weight.page.dart';
import 'package:fit_planner/ui/pages/welcome.page.dart';
import 'package:flutter/material.dart';

import 'ui/pages/gender.page.dart';
import 'ui/pages/goal.page.dart';
import 'ui/pages/name.page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FitPlanner',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF78b500)),
          useMaterial3: true,
        ),
        routes:{
          '/': (context) => UserController.user != null ? const WelcomePage(): const GenderPage(),
          '/page': (context) => const NamePage(user: null, g: 0,),
          '/goal': (context) => const GoalPage(user: null, g: 0, name: '',),
          '/age': (context) => const AgePage(user: null, g: 0, name: '',goal: 0),
          '/height': (context) => const HeightPage(user: null, g: 0, name: '', goal: 0, age: 0),
          '/weight': (context) => const WeightPage(user: null, g: 0, name: '', goal: 0, age: 0, height: 1.0,),
          '/login': (context) => const LoginPage(),
          '/receipt': (context) => RecipePage(),
        }
    );
  }
}








