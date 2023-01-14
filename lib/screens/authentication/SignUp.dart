import 'package:flutter/material.dart';
import 'package:randj_assessment/model/user.dart';
import 'package:randj_assessment/screens/authentication/SignIn.dart';
import 'package:randj_assessment/screens/authentication/VerifyUser.dart';
import 'package:randj_assessment/services/authentication.dart';
import 'package:randj_assessment/shared/loading.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';
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
          'Sign Up',
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
                    'Sign up',
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
                      value!.isEmpty ? 'Name is require' : null),
                  onChanged: (value) {
                    setState(() => name = value);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ),
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
                  validator: ((value) => value!.length < 4
                      ? 'Enter a password 4+ character long'
                      : null),
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
                        child: const Text('Register'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic user = await authService.register(
                                name, email, password);
                            setState(() => loading = false);
                            if (user != null)
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyUser()),
                              );
                          }
                        },
                      )),
              Row(
                children: <Widget>[
                  const Text('Already an account?'),
                  TextButton(
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ]),
          )),
    );
  }
}
