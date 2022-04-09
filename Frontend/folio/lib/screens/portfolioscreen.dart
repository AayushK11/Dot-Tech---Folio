import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final LocalStorage myStorage = LocalStorage('fintech');
  List _portfolioStocks = [];
  String _currentvalue = "";
  double _change = 0.0;
  double _medium = 0.0;
  double _long = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _portfolioStocks = myStorage.getItem("Portfolio") ?? [];
      _currentvalue = myStorage
          .getItem('CurrentValue')
          .toString()
          .replaceAll("null", "0.0");
      _change = myStorage.getItem('Change');
      _medium = myStorage.getItem('MediumTerm');
      _long = myStorage.getItem('LongTerm');
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
                      const Text(
                        'My Portfolio',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontFamily: "Avenir",
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.center,
                        // width: 225,
                        icon: Image.asset('assets/images/add_icon.png'),
                        onPressed: () {},
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 5),
                              child: const Text(
                                'Change %',
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
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                "$_change%",
                                style: TextStyle(
                                    color: (_change > 0.0)
                                        ? const Color(0xff30B451)
                                        : (_change < 0.0)
                                            ? const Color(0xffF44336)
                                            : const Color(0xffffcd4c),
                                    fontSize: 20,
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      ]),
                  const SizedBox(height: 20),
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
                                'Medium Term Outlook',
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
                                (_medium > 0) ? "+$_medium%" : "$_medium%",
                                style: TextStyle(
                                    color: (_medium > 0)
                                        ? const Color(0xff30B451)
                                        : (_medium < 0)
                                            ? const Color(0xffF44336)
                                            : const Color(0xffffcd4c),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: const Text(
                                  'Long Term Outlook',
                                  style: TextStyle(
                                    color: Color(0xffc0c0c0),
                                    fontFamily: "Avenir",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                (_long > 0) ? "+$_long%" : "$_long%",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: (_long > 0)
                                        ? const Color(0xff30B451)
                                        : (_long < 0)
                                            ? const Color(0xffF44336)
                                            : const Color(0xffffcd4c),
                                    fontSize: 20,
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ],
                        ),
                      ]),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      (_long >= _change)
                          ? "Outlook : Stable"
                          : (_medium >= _change)
                              ? "Outlook : Neutral"
                              : "Outlook : Unstable",
                      style: TextStyle(
                        color: (_long >= _change)
                            ? const Color(0xff30B451)
                            : (_medium >= _change)
                                ? const Color(0xffffcd4c)
                                : const Color(0xffF44336),
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
                      "Your Stocks",
                      style: TextStyle(
                          color: Color(0xffc0c0c0),
                          fontSize: 14,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                child: Column(children: [
                  for (var item in _portfolioStocks)
                    portfolioStock(
                        context,
                        item["Company"].toString(),
                        item["LastClose"].toString(),
                        item["Change"].toString(),
                        item["Quantity"].toString(),
                        item["Invested"].toString(),
                        item["Gain"].toString(),
                        item["Logo"].toString(),
                        item["Symbol"].toString()),
                ]),
              ),
              const SizedBox(height: 40)
            ]),
          )
        ]),
      ),
    );
  }
}

portfolioStock(
    context, name, lastClose, change, quantity, invested, gain, logo, symbol) {
  return GestureDetector(
    onTap: () {
      final LocalStorage myStorage = LocalStorage('fintech');
      String _stockCode = symbol;
      myStorage.setItem("stockCode", _stockCode);
    },
    child: Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 10, 5),
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 10),
                      alignment: Alignment.center,
                      child: SvgPicture.network(logo),
                      width: 45,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Qty",
                        style: TextStyle(
                          color: Color(0xffc0c0c0),
                          fontSize: 14,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$quantity",
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 16,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.none,
                        ),
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
                      padding: const EdgeInsets.only(left: 15),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        name,
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
                      child: Row(
                        children: [
                          Text(
                            "Price: $lastClose",
                            style: const TextStyle(
                              color: Color(0xffc0c0c0),
                              fontSize: 14,
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            (double.parse(gain) > 0)
                                ? "↑ $change%"
                                : (double.parse(gain) < 0)
                                    ? "↓ $change%"
                                    : "~ $change%",
                            style: const TextStyle(
                              color: Color(0xffc0c0c0),
                              fontSize: 14,
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.w800,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 0),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 15),
                                child: const Text(
                                  "Invested Value",
                                  style: TextStyle(
                                    color: Color(0xffc0c0c0),
                                    fontSize: 14,
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 0),
                                child: Text(
                                  "₹ $invested",
                                  style: const TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 16,
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 15),
                          Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 15),
                                child: const Text(
                                  "Gain/Loss",
                                  style: TextStyle(
                                    color: Color(0xffc0c0c0),
                                    fontSize: 14,
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  "₹ $gain",
                                  style: const TextStyle(
                                    color: Color(0xffffffff),
                                    fontSize: 16,
                                    fontFamily: "Avenir",
                                    fontWeight: FontWeight.w800,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
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
