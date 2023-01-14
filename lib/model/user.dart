import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String? name;
  final String? email;
  final bool isVerified;
  final int? otp;

  UserData(
      {required this.uid,
      this.email,
      this.name,
      required this.isVerified,
      this.otp});

  factory UserData.fromMap(DocumentSnapshot map) {
    print(map);
    return UserData(
        uid: map.get("uid") ?? '',
        name: map.get("name") ?? '',
        email: map.get("email") ?? '',
        isVerified: map.get("isVerified") ?? false,
        otp: map.get("otp") ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "isVerified": isVerified,
      "otp": otp
    };
  }
}
