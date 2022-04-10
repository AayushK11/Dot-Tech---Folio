import 'package:flutter/material.dart';
import 'package:folio/screens/add_stock_screen.dart';
import 'package:folio/screens/dividendstars.dart';
import 'package:folio/screens/existing_stock_screen.dart';
import 'package:folio/screens/longtermtrades.dart';
import 'package:folio/screens/mediumtermtrades.dart';
import 'package:folio/screens/shorttermtrades.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorage myStorage = LocalStorage('fintech');
  String _name = "";
  String _currentvalue = "";
  String _investedValue = "";
  List _portfolio = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _name = myStorage.getItem('FirstName').toString() +
          " " +
          myStorage.getItem('LastName').toString();
      _currentvalue = myStorage
          .getItem('CurrentValue')
          .toString()
          .replaceAll("null", "0.0");
      _investedValue = myStorage
          .getItem('InvestedValue')
          .toString()
          .replaceAll("null", "0.0");
      try {
        _portfolio = myStorage.getItem('Portfolio');
      } catch (e) {
        _portfolio = [];
      }
    });

    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          Container(
            color: const Color(0xff151321),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 25,
                  right: 15,
                  bottom: 5,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hi, $_name',
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontFamily: "Avenir",
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.center,
                        icon: Image.asset('assets/images/add_icon.png'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              duration: const Duration(milliseconds: 500),
                              type: PageTransitionType.bottomToTop,
                              child: const AddStock(),
                            ),
                          );
                        },
                      ),
                    ]),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 16,
                  left: 25,
                  right: 25,
                  bottom: 10,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xff212230),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              child: const Text(
                                'Your Portfolio\'s Value',
                                style: TextStyle(
                                  color: Color(0xffc0c0c0),
                                  fontFamily: "Avenir",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                "₹ $_currentvalue",
                                style: const TextStyle(
                                    color: Color(0xffffcd4c),
                                    fontSize: 20,
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 25),
                              child: const Text(
                                'Invested Value',
                                style: TextStyle(
                                  color: Color(0xffc0c0c0),
                                  fontFamily: "Avenir",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "₹ $_investedValue",
                              style: TextStyle(
                                  color: (double.parse(_currentvalue) >
                                          double.parse(_investedValue))
                                      ? const Color(0xff30B451)
                                      : (double.parse(_currentvalue) <
                                              double.parse(_investedValue))
                                          ? const Color(0xffF44336)
                                          : const Color(0xffffcd4c),
                                  fontSize: 20,
                                  fontFamily: "Avenir",
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        ),
                      ]),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      (double.parse(_currentvalue) >=
                              double.parse(_investedValue))
                          ? "Your Portfolio is Safe"
                          : "Your Portfolio is in Danger",
                      style: TextStyle(
                        color: (double.parse(_currentvalue) >
                                double.parse(_investedValue))
                            ? const Color(0xff30B451)
                            : (double.parse(_currentvalue) <
                                    double.parse(_investedValue))
                                ? const Color(0xffF44336)
                                : const Color(0xffffcd4c),
                        fontFamily: "Avenir",
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "A Quick Summary",
                      style: TextStyle(
                          color: Color(0xffc0c0c0),
                          fontSize: 16,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 15, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (var item in _portfolio)
                          portfolioStock(
                              context,
                              item["Symbol"].toString(),
                              item["LastClose"].toString(),
                              item["Logo"].toString()),
                      ]),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Our Top Picks",
                      style: TextStyle(
                          color: Color(0xffc0c0c0),
                          fontSize: 16,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ourPicks(
                              context,
                              "Short Term Picks",
                              "1 Day to 3 Weeks",
                              "assets/images/stopwatch_red.png",
                              const ShortTermTrades()),
                          ourPicks(
                              context,
                              "Medium Term Picks",
                              "1 Months to 3 Months",
                              "assets/images/stopwatch_yellow.png",
                              const MediumTermTrades()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ourPicks(
                              context,
                              "Long Term Picks",
                              "3 Months to 1 Year",
                              "assets/images/stopwatch_green.png",
                              const LongTermTrades()),
                          ourPicks(
                              context,
                              "Dividend Stars",
                              "Slow and Steady Growth",
                              "assets/images/MoneyBag.png",
                              const DividendStars()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40)
            ]),
          )
        ]),
      ),
    );
  }
}

portfolioStock(context, name, price, icon) {
  return GestureDetector(
    onTap: () {
      final LocalStorage myStorage = LocalStorage('fintech');
      String _stockCode = name;
      myStorage.setItem("stockCode", _stockCode);
      Navigator.push(
        context,
        PageTransition(
          duration: const Duration(milliseconds: 500),
          type: PageTransitionType.bottomToTop,
          child: const StockScreen(),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xff212230),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: SvgPicture.network(icon),
                  width: 45,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xffc0c0c0),
                          fontFamily: "Avenir",
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        price,
                        style: const TextStyle(
                          color: Color(0xffc0c0c0),
                          fontSize: 14,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
    ),
  );
}

ourPicks(context, name, description, icon, child) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        PageTransition(
          duration: const Duration(milliseconds: 500),
          type: PageTransitionType.bottomToTop,
          child: child,
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
      width: MediaQuery.of(context).size.width * 0.42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xff212230),
      ),
      padding: const EdgeInsets.only(left: 15, right: 15, top: 16, bottom: 16),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Image.asset("$icon"),
              width: 150,
              height: 150,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                name,
                maxLines: 1,
                style: const TextStyle(
                  color: Color(0xffc0c0c0),
                  fontFamily: "Avenir",
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                description,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xffc0c0c0),
                  fontFamily: "Avenir",
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ]),
    ),
  );
}
