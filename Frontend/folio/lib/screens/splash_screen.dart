import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
// import required -> login
// impoort required -> bottom nav bar

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

    const baseURL = 'http://<link>/api';
    final url = Uri.parse('$baseURL/login/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212230),
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
