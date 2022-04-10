import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:folio/screens/stock_basic_info_screen.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';

class DividendStars extends StatefulWidget {
  const DividendStars({Key? key}) : super(key: key);

  @override
  State<DividendStars> createState() => _DividendStarsState();
}

class _DividendStarsState extends State<DividendStars> {
  final LocalStorage myStorage = LocalStorage('fintech');
  String _stockCode = "";

  @override
  void initState() {
    super.initState();
  }

  _sendDetails() async {
    await myStorage.ready;

    const baseURL = 'http://4a67-110-226-206-82.ngrok.io/api';
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
          'Dividend Stars',
          style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              fontFamily: "avenir"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: const Color(0xff151321),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 0,
                  left: 15,
                  right: 15,
                  bottom: 10,
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  stocktabs(
                      context,
                      "Hindustan Unilever Ltd.",
                      "https://s3-symbol-logo.tradingview.com/unilever--big.svg",
                      "2183.05",
                      "HINDUNILVR"),
                  const SizedBox(height: 20),
                  stocktabs(
                      context,
                      "Britannia Industries Ltd.",
                      "https://s3-symbol-logo.tradingview.com/britannia--big.svg",
                      "3347.9",
                      "BRITANNIA"),
                  const SizedBox(height: 20),
                  stocktabs(
                      context,
                      "HCL Technologies Ltd.",
                      "https://s3-symbol-logo.tradingview.com/hcl-technologies--big.svg",
                      "1165.35",
                      "HCLTECH"),
                  const SizedBox(height: 20),
                  stocktabs(
                      context,
                      "ITC Ltd.",
                      "https://s3-symbol-logo.tradingview.com/itc--big.svg",
                      "267.08",
                      "ITC"),
                  const SizedBox(height: 20),
                  stocktabs(
                      context,
                      "Infosys Ltd.",
                      "https://s3-symbol-logo.tradingview.com/infosys--big.svg",
                      "1814.6",
                      "INFY"),
                  const SizedBox(height: 20),
                  stocktabs(
                      context,
                      "Coal India Ltd.",
                      "https://s3-symbol-logo.tradingview.com/coal-india--big.svg",
                      "194.55",
                      "COALINDIA"),
                  const SizedBox(height: 20),
                  stocktabs(
                      context,
                      "Bharat Petroleum Corporation Ltd.",
                      "https://s3-symbol-logo.tradingview.com/bharat-petroleum--big.svg",
                      "384.55",
                      "BPCL"),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
