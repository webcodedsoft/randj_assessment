import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randj_assessment/model/user.dart';
import 'package:randj_assessment/screens/wrapper.dart';
import 'package:randj_assessment/services/authentication.dart';
import 'package:randj_assessment/shared/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // final Future<FirebaseApp> _initFirebaseSdk = Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        scaffoldMessengerKey: Utils.messageKey,
        home: Wrapper(),
      ),
    );
  }
}
