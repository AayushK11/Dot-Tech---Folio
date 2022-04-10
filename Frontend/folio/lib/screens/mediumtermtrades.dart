import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:folio/screens/stock_basic_info_screen.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';

class MediumTermTrades extends StatefulWidget {
  const MediumTermTrades({Key? key}) : super(key: key);

  @override
  State<MediumTermTrades> createState() => _MediumTermTradesState();
}

class _MediumTermTradesState extends State<MediumTermTrades> {
  final LocalStorage myStorage = LocalStorage('fintech');
  String _stockCode = "";

  @override
  void initState() {
    super.initState();
  }

  _sendDetails() async {
    await myStorage.ready;

    const baseURL = 'http://7cdb-110-226-206-82.ngrok.io/api';
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
      Navigator.push(
        context,
        PageTransition(
          duration: const Duration(milliseconds: 500),
          type: PageTransitionType.bottomToTop,
          child: const NewStockScreen(),
        ),
      );
    } else if (responseMessage == "Stock Does Not Exist") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Stock Not Found."),
        backgroundColor: Color(0xFFE43434),
      ));
    }
  }

  stocktabs(context, company, logo, lastprice, symbol) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _stockCode = symbol;
        });
        _sendDetails();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xff212230),
        ),
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 5,
          bottom: 15,
        ),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: SvgPicture.network(logo),
                width: 80,
              ),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        company,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontFamily: "Avenir",
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Price: ₹ $lastprice",
                        style: const TextStyle(
                          color: Color(0xffc0c0c0),
                          fontSize: 14,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ]),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Medium Term Picks',
          style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              fontFamily: "avenir"),
        ),
      ),
      body: SafeArea(
          child: Container(
        color: const Color(0xff151321),
        child: Column(children: [
          Container(
            margin: const EdgeInsets.only(
              top: 23,
              left: 15,
              right: 15,
              bottom: 10,
            ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              stocktabs(
                  context,
                  "HDFC Bank Ltd.",
                  "https://s3-symbol-logo.tradingview.com/hdfc-bank--big.svg",
                  "1514.65",
                  "HDFCBANK"),
              const SizedBox(height: 20),
              stocktabs(
                  context,
                  "HDFC Bank Ltd.",
                  "https://s3-symbol-logo.tradingview.com/hdfc-bank--big.svg",
                  "1514.65",
                  "HDFCBANK"),
              const SizedBox(height: 20),
              stocktabs(
                  context,
                  "HDFC Bank Ltd.",
                  "https://s3-symbol-logo.tradingview.com/hdfc-bank--big.svg",
                  "1514.65",
                  "HDFCBANK"),
              const SizedBox(height: 20),
              stocktabs(
                  context,
                  "HDFC Bank Ltd.",
                  "https://s3-symbol-logo.tradingview.com/hdfc-bank--big.svg",
                  "1514.65",
                  "HDFCBANK"),
              const SizedBox(height: 20),
              stocktabs(
                  context,
                  "HDFC Bank Ltd.",
                  "https://s3-symbol-logo.tradingview.com/hdfc-bank--big.svg",
                  "1514.65",
                  "HDFCBANK"),
              const SizedBox(height: 20),
            ]),
          ),
        ]),
      )),
    );
  }
}
