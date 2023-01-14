import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:randj_assessment/screens/authentication/SignIn.dart';
import 'package:randj_assessment/services/authentication.dart';
import 'package:randj_assessment/services/database.dart';
import 'package:randj_assessment/shared/loading.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService authService = AuthService();
  final DatabaseService db = DatabaseService();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot?>(
        future: db.getUser(authService.getUserId()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Welcome ${snapshot.data?.get("name")}!"),
                backgroundColor: Colors.blue[600],
                elevation: 0.0,
                actions: <Widget>[
                  TextButton.icon(
                    onPressed: () async {
                      await authService.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    label: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 90.0, horizontal: 50.0),
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text("Name: ${snapshot.data?.get("name")}"),
                        Text("Email: ${snapshot.data?.get("email")}")
                      ],
                    )),
              ),
            );
          }
          return Loading();
        });
  }
}
