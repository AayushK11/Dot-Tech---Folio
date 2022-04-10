import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart';
import 'dart:convert';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  final LocalStorage myStorage = LocalStorage('fintech');
  String _email = "";
  String _stockCode = "";
  String _quantity = "";
  String _buyPrice = "";

  @override
  void initState() {
    super.initState();
  }

  _login() async {
    await myStorage.ready;

    const baseURL = 'http://7cdb-110-226-206-82.ngrok.io/api';
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
    _sendDetails() async {
      await myStorage.ready;

      _email = myStorage.getItem('Email').toString();

      const baseURL = 'http://7cdb-110-226-206-82.ngrok.io/api';
      final url = Uri.parse('$baseURL/addstock/');

      Response response = await post(url, body: {
        'email': _email.toString(),
        'stock': _stockCode.toString(),
        'quantity': _quantity.toString(),
        'buyingprice': _buyPrice.toString(),
      });

      final responseJson = jsonDecode(response.body);
      final responseMessage = responseJson['message'];

      if (responseMessage == "Added to Portfolio") {
        _login();
        Navigator.pop(context);
      } else if (responseMessage == "Stock Does Not Exist") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Stock Does not Exist"),
          backgroundColor: Color(0xFFE43434),
        ));
      }
    }

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
        title: const Text(
          'Add Stock',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Container(
              color: const Color(0xff151321),
              child: Column(children: [
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
                      labelText: 'Stock Name',
                      labelStyle: TextStyle(
                        color: Color(0xff00c9ff),
                        fontSize: 18,
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
                    onChanged: (value) {
                      setState(() {
                        _stockCode = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 25,
                        right: 5,
                        bottom: 5,
                      ),
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        style: const TextStyle(
                          color: Color(0xff00c9ff),
                          fontSize: 20,
                          fontFamily: "avenir",
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
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
                                color: Color(0xffc0c0c0), width: 0.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _quantity = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 25,
                        right: 5,
                        bottom: 5,
                      ),
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: true,
                        ),
                        style: const TextStyle(
                          color: Color(0xff00c9ff),
                          fontSize: 20,
                          fontFamily: "avenir",
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Buying Price',
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
                                color: Color(0xffc0c0c0), width: 0.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _buyPrice = value;
                          });
                        },
                      ),
                    ),
                  ],
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
                        'Add Stock To Portfolio',
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
            )
          ]),
        ),
      ),
    );
  }
}
