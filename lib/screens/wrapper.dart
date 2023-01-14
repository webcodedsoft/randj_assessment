import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randj_assessment/model/user.dart';
import 'package:randj_assessment/screens/authenticated/authenticated.dart';
import 'package:randj_assessment/screens/authentication/SignIn.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    // redirect user to either home or sign-up widget
    if (user == null) {
      return const SignIn();
    } else {
      return const Authenticated();
    }
  }
}
