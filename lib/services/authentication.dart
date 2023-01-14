import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:localstorage/localstorage.dart';
import 'package:randj_assessment/model/user.dart';
import 'package:randj_assessment/services/database.dart';
import 'package:randj_assessment/shared/utils.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static final _localAuth = LocalAuthentication();
  final LocalStorage storage = new LocalStorage('localstorage_app');

  UserData? _fireBaseUser(User? user) {
    return user != null ? UserData(uid: user.uid, isVerified: false) : null;
  }

  Stream<UserData?> get user {
    return auth.authStateChanges().map(_fireBaseUser);
  }

  String? getUserId() {
    return auth.currentUser?.uid;
  }

  Future addLocalStorage(user) async {
    final info = json.encode(user);
    dynamic ready = await storage.ready;
    if (ready) {
      await storage.setItem('userInfo', info);
    }
  }

  Future register(String name, String email, String password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      final info = {
        'userId': user?.uid,
        'userEmail': user?.email,
        'name': name,
        'isVerified': false,
        'password': password
      };
      await DatabaseService().createUser(user?.uid, user?.email, name);
      addLocalStorage(info);
      storage.setItem('userInfo', info);

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.showSnackBar("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Utils.showSnackBar("The account already exists for that email.");
      }
    }
  }

  Future login(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      DocumentSnapshot<Object?>? userData =
          await DatabaseService().getUser(user?.uid);

      final info = {
        'userId': user?.uid,
        'userEmail': user?.email,
        'name': userData?.get('name'),
        'isVerified': userData?.get('isVerified'),
        'password': password
      };
      await addLocalStorage(info);
      // return _fireBaseUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.showSnackBar("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Utils.showSnackBar("Wrong password provided for that user.");
      }
    }
  }

  Future verifyUser(String? userId, int? otp) async {
    try {
      DocumentSnapshot<Object?>? user = await DatabaseService().getUser(userId);
      int userOTP = user?.get("otp");
      if (userOTP == otp) {
        dynamic result = await DatabaseService().markUserAsVerified(userId);
        return true;
      } else {
        Utils.showSnackBar("Invalid OTP Provided");
      }
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.showSnackBar("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Utils.showSnackBar("Wrong password provided for that user.");
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future logout() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> canAuthenticate() async {
    return await _localAuth.canCheckBiometrics ||
        await _localAuth.isDeviceSupported();
  }

  Future<bool> authFaceID() async {
    final isAvailable = await canAuthenticate();
    if (!isAvailable) return false;

    try {
      var ready = await storage.ready;
      var userJson = await storage.getItem('userInfo');
      Map<String, dynamic> userInfo = {};

      if (userJson != null) {
        userInfo = json.decode(userJson);
      }
      final userEmail = userInfo['userEmail'];
      final userPassword = userInfo['password'];
      final isVerified = userInfo['isVerified'];

      dynamic result = await _localAuth.authenticate(
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Sign in',
              cancelButton: 'No thanks',
            ),
            IOSAuthMessages(
              cancelButton: 'No thanks',
            ),
          ],
          localizedReason: 'Use Face ID to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            // biometricOnly: true,
            useErrorDialogs: true,
          ));

      if (result && userEmail != null && userPassword != null) {
        await login(userEmail, userPassword);
      }
      return isVerified != null;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> storageExist() async {
    await storage.ready;
    var userJson = await storage.getItem('userInfo');
    return userJson != null;
  }
}
