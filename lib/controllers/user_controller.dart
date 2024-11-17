import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController {
  
  static User ? user = FirebaseAuth.instance.currentUser;

  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();

    final googleAuth = await googleAccount?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
    );

    return userCredential.user;
  }


  static Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential('${loginResult.accessToken?.tokenString}');

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }


  static Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }



  static Future<User?> loginWithEmailPassword(String email, String password) async {

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }


  static Future<int> userExists(User? user) async {
    if (user == null) {
      print("User is null!!.");
      return -1;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await userRef.get();

    if (!docSnapshot.exists) {
      return 0;
    } else {
      return 1;
    }
  }

  static Future<void> saveUser(User? user,int g,String name,int goal, int age, double height, double weight) async{
    if (user == null) {
      print("User is null, cannot save to database.");
      return;
    }

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userRef.set({
      'name': name,
      'email': user.email,
      'createdAt': Timestamp.now(),
      'gender': g,
      'goal': goal,
      'age': age,
      'height': height,
      'weight': weight,
    });
  }

  static Future<String> getName (User? user) async{
    final userRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    final docSnapshot = await userRef.get();

    if (docSnapshot.exists) {
      var userData = docSnapshot.data();
      String? name = userData?['name'];
      if (name != null) {
        return name;
      }
    }
    return "";
  }

  static Future<int> requiredKcal (User? user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    final docSnapshot = await userRef.get();

    if (docSnapshot.exists) {
      var userData = docSnapshot.data();

      int? gender = userData?['gender'];
      int? goal = userData?['goal'];
      int? age = userData?['age'];
      double? height = userData?['height'];
      double? weight = userData?['weight'];

      double required = (10 * weight!) + (6.25 * height!) - (5 * age!);
      if(gender == 0){
        required += 5;
      } else{
        required -= 16;
      }
      if(goal == 1){
        required += 500;
      } else if(goal == 2){
        required -= 500;
      }
      required /= 3;
      return required.toInt();
    }
    else return -1;
  }

}