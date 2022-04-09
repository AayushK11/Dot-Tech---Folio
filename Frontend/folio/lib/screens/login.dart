import 'package:flutter/material.dart';
import 'package:folio/screens/bottom_navigation.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LocalStorage myStorage = LocalStorage('fintech');
  String _email = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _passwordVisible = false;

    _login() async {
      await myStorage.ready;

      const baseURL = 'http://166a-110-226-206-82.ngrok.io/api';
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login Failed. Please Check Your Credentials."),
          backgroundColor: Color(0xFFE43434),
        ));
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF10111A),
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 150, left: 50),
                child: Row(children: [
                  const SizedBox(width: 40),
                  Image.asset(
                    'assets/images/favicon.png',
                    width: 120,
                  ),
                  const SizedBox(width: 10),
                  Container(
                    margin: const EdgeInsets.only(left: 0, top: 19),
                    child: const Text(
                      'folio',
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Avenir",
                        fontWeight: FontWeight.bold,
                        color: Color(0xffFFD632),
                      ),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color(0xff00c9ff),
                    fontSize: 20,
                    fontFamily: "avenir",
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Email ID',
                    labelStyle: TextStyle(
                      color: Color(0xff00c9ff),
                      fontSize: 20,
                      fontFamily: "avenir",
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff00c9ff)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffc0c0c0), width: 0.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  autofillHints: const [AutofillHints.password],
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_passwordVisible,
                  style: const TextStyle(
                    color: Color(0xff00c9ff),
                    fontSize: 20,
                    fontFamily: "avenir",
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color(0xff00c9ff),
                      fontSize: 20,
                      fontFamily: "avenir",
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff00c9ff)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffc0c0c0), width: 0.0),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 150),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 40, left: 35, right: 35),
                child: TextButton(
                  onPressed: () {
                    _login();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff00c9ff),
                    ),
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 15,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
