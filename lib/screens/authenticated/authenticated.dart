import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:randj_assessment/screens/authentication/VerifyUser.dart';
import 'package:randj_assessment/screens/dashboard/home.dart';
import 'package:randj_assessment/services/authentication.dart';
import 'package:randj_assessment/services/database.dart';
import 'package:randj_assessment/shared/loading.dart';

class Authenticated extends StatefulWidget {
  const Authenticated({super.key});

  @override
  State<Authenticated> createState() => _AuthenticatedState();
}

class _AuthenticatedState extends State<Authenticated> {
  final AuthService authService = AuthService();
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.getUser(authService.getUserId()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.get('isVerified')) {
              return const Home();
            } else {
              return const VerifyUser();
            }
          }
          return Scaffold(
            backgroundColor: Color(0xfff7f6fb),
            body: SafeArea(child: Loading()),
          );
        });
  }
}
