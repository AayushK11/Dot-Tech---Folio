import 'package:flutter/material.dart';
import 'package:folio/screens/add_stock_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class NewStockScreen extends StatefulWidget {
  const NewStockScreen({Key? key}) : super(key: key);

  @override
  State<NewStockScreen> createState() => _NewStockScreenState();
}

class _NewStockScreenState extends State<NewStockScreen> {
  final LocalStorage myStorage = LocalStorage('fintech');
  String _stockCode = "";
  String _company = "";
  String _logo = "";
  String _lastprice = "";
  String _day = "";
  String _week = "";
  String _month = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _stockCode = myStorage.getItem('StockCode');
      _company = myStorage.getItem('Company');
      _logo = myStorage.getItem('Logo');
      _lastprice = myStorage.getItem('LastClose');
      _day = myStorage.getItem('DayPred');
      _week = myStorage.getItem('WeekPred');
      _month = myStorage.getItem('MonthPred');
    });

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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
              const SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Last Close",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color(0xffffcd4c),
                              fontSize: 24,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹ $_lastprice",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Color(0xffffcd4c),
                              fontSize: 22,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ]),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Day Forecast",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Color(0xffffcd4c),
                              fontSize: 24,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹ $_day",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: (double.parse(_day) >
                                      double.parse(_lastprice))
                                  ? const Color(0xff2ecc71)
                                  : (double.parse(_day) ==
                                          double.parse(_lastprice))
                                      ? const Color(0xffffcd4c)
                                      : const Color(0xffF44336),
                              fontSize: 22,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Week Forecast",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color(0xffffcd4c),
                              fontSize: 24,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹ $_week",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: (double.parse(_week) >
                                      double.parse(_lastprice))
                                  ? const Color(0xff2ecc71)
                                  : (double.parse(_week) ==
                                          double.parse(_lastprice))
                                      ? const Color(0xffffcd4c)
                                      : const Color(0xffF44336),
                              fontSize: 22,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ]),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Month Forecast",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Color(0xffffcd4c),
                              fontSize: 24,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹ $_month",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: (double.parse(_month) >
                                      double.parse(_lastprice))
                                  ? const Color(0xff2ecc71)
                                  : (double.parse(_month) ==
                                          double.parse(_lastprice))
                                      ? const Color(0xffffcd4c)
                                      : const Color(0xffF44336),
                              fontSize: 22,
                              fontFamily: "avenir",
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.center,
                child: Text(
                  (double.parse(_month) >= double.parse(_lastprice))
                      ? "Outlook : Stable"
                      : (double.parse(_week) >= double.parse(_lastprice))
                          ? "Outlook : Neutral"
                          : "Outlook : Unstable",
                  style: TextStyle(
                    color: (double.parse(_month) >= double.parse(_lastprice))
                        ? const Color(0xff30B451)
                        : (double.parse(_week) >= double.parse(_lastprice))
                            ? const Color(0xffffcd4c)
                            : const Color(0xffF44336),
                    fontFamily: "Avenir",
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 140),
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
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: const Duration(milliseconds: 500),
                        type: PageTransitionType.bottomToTop,
                        child: const AddStock(),
                      ),
                    ).then((value) => Navigator.pop(context));
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
                      'Add To Portfolio',
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
      ),
    );
  }
}
