import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:folio/screens/bottom_navigation.dart';
import 'package:folio/screens/login.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorage myStorage = LocalStorage('fintech');

  @override
  void initState() {
    super.initState();
    loginCheck();
  }

  Future<void> loginCheck() async {
    await myStorage.ready;

    final _email = await myStorage.getItem('Email');
    final _password = await myStorage.getItem('Password');

    const baseURL = 'http://0fbe-110-226-206-82.ngrok.io/api';
    final url = Uri.parse('$baseURL/login/');

    Response response = await post(url, body: {
      'email': _email.toString(),
      'password': _password.toString(),
    });

    final responseJson = jsonDecode(response.body);
    final responseMessage = responseJson['message'];

    if (responseMessage == "Login Successful") {
      await myStorage.setItem("FirstName", responseJson['firstname']);
      await myStorage.setItem("LastName", responseJson['lastname']);
      await myStorage.setItem("Email", _email);
      await myStorage.setItem("Password", _password);
      await myStorage.setItem("CurrentValue", responseJson['portfoliovalue']);
      await myStorage.setItem("InvestedValue", responseJson['investedvalue']);
      await myStorage.setItem("Portfolio", responseJson['portfolio']);
      await myStorage.setItem("Change", responseJson['change']);
      await myStorage.setItem("MediumTerm", responseJson['medium']);
      await myStorage.setItem("LongTerm", responseJson['long']);
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 500),
            type: PageTransitionType.rightToLeft,
            child: const BottomNavigation(),
          ),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 500),
            type: PageTransitionType.rightToLeft,
            child: const Login(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10111A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/favicon.png',
                width: 175,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              child: (const Text(
                'Folio',
                style: TextStyle(
                    color: Color(0xff00c9ff),
                    fontFamily: "Avenir",
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
