import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'package:http/http.dart';

class SearchStock extends StatefulWidget {
  const SearchStock({Key? key}) : super(key: key);

  @override
  State<SearchStock> createState() => _SearchStockState();
}

class _SearchStockState extends State<SearchStock> {
  String _stockCode = "";
  final LocalStorage myStorage = LocalStorage('fintech');

  @override
  void initState() {
    super.initState();
  }

  _sendDetails() async {
    await myStorage.ready;

    const baseURL = 'http://166a-110-226-206-82.ngrok.io/api';
    final url = Uri.parse('$baseURL/search/');

    Response response = await post(url, body: {
      'stock': _stockCode.toString(),
      "email": await myStorage.getItem('Email'),
      'purpose': "Search",
    });

    final responseJson = jsonDecode(response.body);
    final responseMessage = responseJson['message'];

    if (responseMessage == "Found") {
      await myStorage.setItem("StockCode", _stockCode);
      await myStorage.setItem("Company", responseJson['company']);
      await myStorage.setItem("Logo", responseJson['logo']);
      await myStorage.setItem("DayPred", responseJson['day']);
      await myStorage.setItem("WeekPred", responseJson['week']);
      await myStorage.setItem("MonthPred", responseJson['month']);
      await myStorage.setItem("LastClose", responseJson['last']);
      // Show Stock Info
    } else if (responseMessage == "Stock Does Not Exist") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Stock Not Found."),
        backgroundColor: Color(0xFFE43434),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xff151321),
        child: Column(children: [
          Container(
            color: const Color(0xff151321),
            child: Column(children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 25,
                  right: 15,
                  bottom: 5,
                ),
                child: const Text(
                  'Find A Stock',
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontFamily: "Avenir",
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 25,
                  right: 25,
                  bottom: 5,
                ),
                child: TextField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    color: Color(0xff00c9ff),
                    fontSize: 20,
                    fontFamily: "avenir",
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Stock Short Code',
                    labelStyle: TextStyle(
                      color: Color(0xff00c9ff),
                      fontSize: 18,
                      fontFamily: "avenir",
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff00c9ff)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffc0c0c0),
                        width: 0.0,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _stockCode = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 35),
              Container(
                padding: const EdgeInsets.only(
                  top: 5,
                  left: 20,
                  right: 20,
                  bottom: 5,
                ),
                alignment: Alignment.center,
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
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "avenir",
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 150),
              const Text(
                'Search Something You Want\nSearch Something You Need\nSearch With Folio\nEarn When You Sleep',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontFamily: "Avenir",
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.none,
                ),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
