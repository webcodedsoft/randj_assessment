import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:randj_assessment/model/user.dart';
import 'package:randj_assessment/screens/dashboard/home.dart';
import 'package:randj_assessment/services/authentication.dart';
import 'package:randj_assessment/services/database.dart';
import 'package:randj_assessment/shared/loading.dart';
import 'package:randj_assessment/shared/utils.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({super.key});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final AuthService authService = AuthService();
  final DatabaseService db = DatabaseService();

  String otp1 = '';
  String otp2 = '';
  String otp3 = '';
  String otp4 = '';
  bool loading = false;
  Object user = {};

  void _handleChange(name, value) {
    if (name == 'otp1') setState(() => otp1 = value);
    if (name == 'otp2') setState(() => otp2 = value);
    if (name == 'otp3') setState(() => otp3 = value);
    if (name == 'otp4') setState(() => otp4 = value);
  }

  void handleSubmit() async {
    setState(() => loading = true);
    int otp = int.parse('${otp1}${otp2}${otp3}${otp4}');

    dynamic result = await authService.verifyUser(authService.getUserId(), otp);
    setState(() => loading = false);
    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Enter your OTP code number",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 38,
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldOTP(
                            first: true, last: false, fieldName: 'otp1'),
                        _textFieldOTP(
                            first: false, last: false, fieldName: 'otp2'),
                        _textFieldOTP(
                            first: false, last: false, fieldName: 'otp3'),
                        _textFieldOTP(
                            first: false, last: true, fieldName: 'otp4'),
                      ],
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    loading
                        ? Loading()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (otp1 != null &&
                                    otp2 != null &&
                                    otp3 != null &&
                                    otp4 != null) {
                                  handleSubmit();
                                }
                                // await authService.logout();
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
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Verify',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          )
                  ],
                ),
                SizedBox(
                  height: 18,
                ),
                FutureBuilder<DocumentSnapshot?>(
                    future: db.getUser(authService.getUserId()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          "Valid OTP: ${snapshot.data!.get("otp")}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                          textAlign: TextAlign.center,
                        );
                      }
                      return Column(
                        children: <Widget>[
                          SizedBox(
                            height: 90,
                          ),
                          Text(
                            'Something went wrong',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                SizedBox(
                  height: 18,
                ),
              ],
            )),
      ),
    );
  }

  Widget _textFieldOTP(
      {required bool first, last = false, required String fieldName}) {
    return Container(
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            _handleChange(fieldName, value);
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.blue),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
