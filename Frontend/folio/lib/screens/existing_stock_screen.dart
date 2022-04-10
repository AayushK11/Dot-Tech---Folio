import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final LocalStorage myStorage = LocalStorage('fintech');
  String _stockCode = "";
  String _email = "";
  String _company = "";
  String _logo = "";
  String _lastprice = "";
  String _price = "";
  double _change = 0.0;
  String _day = "";
  double _dayChange = 0.0;
  String _week = "";
  double _weekChange = 0.0;
  String _month = "";
  double _monthChange = 0.0;
  String _quantity = "";

  @override
  void initState() {
    super.initState();
    _getStockDetails();
  }

  _getStockDetails() async {
    _stockCode = await myStorage.getItem('stockCode');
    _email = await myStorage.getItem('Email');

    const baseURL = 'http://4a67-110-226-206-82.ngrok.io/api';
    final url = Uri.parse('$baseURL/search/');

    Response response = await post(url, body: {
      'stockCode': _stockCode,
      'email': _email,
      'purpose': "existing",
    });

    final responseJson = jsonDecode(response.body);
    final responseMessage = responseJson['message'];

    if (responseMessage == "Success") {
      setState(() {
        _company = responseJson['company'];
        _logo = responseJson['logo'];
        _lastprice = responseJson['Last'];
        _price = responseJson['buyingprice'];
        _change = responseJson['Change'];
        _day = responseJson['Day'];
        _dayChange = responseJson['DayChange'];
        _week = responseJson['Week'];
        _weekChange = responseJson['WeekChange'];
        _month = responseJson['Month'];
        _monthChange = responseJson['MonthChange'];
        _quantity = responseJson['quantity'];
      });
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("There was some error"),
        backgroundColor: Color(0xFFE43434),
      ));
    }
  }

  _sendDetails() async {
    const baseURL = 'http://4a67-110-226-206-82.ngrok.io/api';
    final url = Uri.parse('$baseURL/removestock/');

    await myStorage.ready;

    Response response = await post(url, body: {
      'stock': _stockCode,
      'email': _email,
    });

    final responseJson = jsonDecode(response.body);
    final responseMessage = responseJson['message'];

    if (responseMessage == "Removed from Portfolio") {
      await myStorage.setItem("PortfolioValue", responseJson['portfoliovalue']);
      await myStorage.setItem("InvestedValue", responseJson['investedvalue']);
      await myStorage.setItem("Change", responseJson['change']);
      await myStorage.setItem("MediumTerm", responseJson['medium']);
      await myStorage.setItem("LongTerm", responseJson['long']);
      _login();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("There was some error"),
        backgroundColor: Color(0xFFE43434),
      ));
    }
  }

  _login() async {
    await myStorage.ready;

    const baseURL = 'http://4a67-110-226-206-82.ngrok.io/api';
    final url = Uri.parse('$baseURL/login/');

    Response response = await post(url, body: {
      'email': myStorage.getItem('Email').toString(),
      'password': myStorage.getItem('Password').toString(),
    });

    final responseJson = jsonDecode(response.body);
    final responseMessage = responseJson['message'];

    if (responseMessage == "Login Successful") {
      await myStorage.setItem("FirstName", responseJson['firstname']);
      await myStorage.setItem("LastName", responseJson['lastname']);
      await myStorage.setItem("CurrentValue", responseJson['portfoliovalue']);
      await myStorage.setItem("InvestedValue", responseJson['investedvalue']);
      await myStorage.setItem("Portfolio", responseJson['portfolio']);
      await myStorage.setItem("Change", responseJson['change']);
      await myStorage.setItem("MediumTerm", responseJson['medium']);
      await myStorage.setItem("LongTerm", responseJson['long']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Login Failed. Please Check Your Credentials."),
        backgroundColor: Color(0xFFE43434),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    _stockCode = myStorage.getItem('stockCode');

    return Scaffold(
      backgroundColor: const Color(0xff151321),
      appBar: AppBar(
        backgroundColor: const Color(0xff151321),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _stockCode,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontFamily: "avenir",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 25),
                  child: SvgPicture.network(_logo),
                  width: 150,
                  height: 150,
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      _company,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: "avenir",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Last Close",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xffffcd4c),
                            fontSize: 22,
                            fontFamily: "avenir",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₹ $_lastprice",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Color(0xffffcd4c),
                            fontSize: 20,
                            fontFamily: "avenir",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const Text(
                      "Buying Price",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Color(0xffffcd4c),
                        fontSize: 22,
                        fontFamily: "avenir",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(children: [
                      Text(
                        "₹ $_price",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (_change > 0)
                              ? const Color(0xff30B451)
                              : const Color(0xffE43434),
                          fontSize: 20,
                          fontFamily: "avenir",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ($_change%)",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (_change > 0)
                              ? const Color(0xff30B451)
                              : const Color(0xffE43434),
                          fontSize: 14,
                          fontFamily: "avenir",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Day Forecast",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xffffcd4c),
                            fontSize: 22,
                            fontFamily: "avenir",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(children: [
                          Text(
                            "₹ $_day",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: (_dayChange > 0)
                                  ? const Color(0xff30B451)
                                  : const Color(0xffE43434),
                              fontSize: 20,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " ($_dayChange%)",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: (_dayChange > 0)
                                  ? const Color(0xff30B451)
                                  : const Color(0xffE43434),
                              fontSize: 14,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const Text(
                      "Week Forecast",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Color(0xffffcd4c),
                        fontSize: 22,
                        fontFamily: "avenir",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(children: [
                      Text(
                        "₹ $_week",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (_weekChange > 0)
                              ? const Color(0xff30B451)
                              : const Color(0xffE43434),
                          fontSize: 20,
                          fontFamily: "avenir",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ($_weekChange%)",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (_weekChange > 0)
                              ? const Color(0xff30B451)
                              : const Color(0xffE43434),
                          fontSize: 14,
                          fontFamily: "avenir",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Month Forecast",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xffffcd4c),
                            fontSize: 22,
                            fontFamily: "avenir",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(children: [
                          Text(
                            "₹ $_month",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: (_monthChange > 0)
                                  ? const Color(0xff30B451)
                                  : const Color(0xffE43434),
                              fontSize: 20,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " ($_monthChange%)",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: (_monthChange > 0)
                                  ? const Color(0xff30B451)
                                  : const Color(0xffE43434),
                              fontSize: 14,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const Text(
                      "Quantity",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Color(0xffffcd4c),
                        fontSize: 22,
                        fontFamily: "avenir",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _quantity,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Color(0xffffcd4c),
                        fontSize: 20,
                        fontFamily: "avenir",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.center,
              child: Text(
                (_monthChange >= _change)
                    ? "Outlook : Stable"
                    : (_weekChange >= _change)
                        ? "Outlook : Neutral"
                        : "Outlook : Unstable",
                style: TextStyle(
                  color: (_monthChange >= _change)
                      ? const Color(0xff30B451)
                      : (_weekChange >= _change)
                          ? const Color(0xffffcd4c)
                          : const Color(0xffF44336),
                  fontFamily: "Avenir",
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
                bottom: 5,
              ),
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  _sendDetails();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 25,
                    right: 25,
                    bottom: 10,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xff00c9ff),
                  ),
                  child: const Text(
                    'Remove From Portfolio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "avenir",
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
