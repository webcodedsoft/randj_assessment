import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:randj_assessment/screens/authentication/SignUp.dart';
import 'package:randj_assessment/screens/authentication/VerifyUser.dart';
import 'package:randj_assessment/screens/dashboard/home.dart';
import 'package:randj_assessment/services/authentication.dart';
import 'package:randj_assessment/shared/loading.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final LocalStorage storage = new LocalStorage('localstorage_app');

  String email = '';
  String password = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white38,
        elevation: 0.0,
        title: Text(
          'Sign In',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              SizedBox(height: 90.0),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Welcome back folks!',
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: ((value) =>
                      value!.isEmpty ? 'Email is require' : null),
                  onChanged: (value) {
                    setState(() => email = value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  validator: ((value) =>
                      value!.isEmpty ? 'Password is require' : null),
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              loading
                  ? Loading()
                  : Container(
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            Object? result =
                                await authService.login(email, password);
                          }
                        },
                      )),
              Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(height: 40),
              Column(
                children: <Widget>[
                  FutureBuilder<bool>(
                      future: authService.storageExist(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data == true) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                bool result = await authService.authFaceID();
                                if (result) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VerifyUser()),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Authenticate Using Face ID',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Text(
                              'You need to login and logout to enable Face ID ');
                        }
                      })
                ],
              ),
            ]),
          )),
    );
  }
}
