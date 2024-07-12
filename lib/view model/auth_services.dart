import 'package:deadlinemanager/views/addForm.dart';
import 'package:deadlinemanager/views/userLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // Sign up with email and password
  signUpUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => UserLogin())));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registeration Successfull')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email Provided already exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // SignIn with email and password
  signInUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddFormData())));

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You are loggedIn')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Enter correct password')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  //SignIn with google account
  signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);

    if (userCredential.user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddFormData()));
    }
  }

  //Sign out from google account
  Future<void> signOutGoogle(BuildContext context) async {
    try {
      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();
      print('User signed out from Firebase');

      // Sign out from Google Sign-In
      await GoogleSignIn().signOut();

      print('User signed out from Google');
      // Navigator.pop(context);
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
