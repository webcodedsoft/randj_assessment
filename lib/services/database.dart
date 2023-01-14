import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randj_assessment/model/user.dart';

class DatabaseService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(String? uid, String? email, String name) async {
    var rng = new Random();
    var otp = rng.nextInt(9000) + 1000;

    await usersCollection
        .doc(uid)
        .set({"name": name, "email": email, "isVerified": false, "otp": otp});
  }

  Future markUserAsVerified(String? uid) async {
    return await usersCollection
        .doc(uid)
        .update({"isVerified": true, "otp": ''});
  }

  Future<DocumentSnapshot?> getUser(userId) async {
    final snapshot = await usersCollection.doc(userId).get();
    return snapshot;
    // return UserData.fromMap(snapshot);
  }
}
