import 'package:flutter/material.dart';
import 'package:folio/screens/portfolioscreen.dart';
import 'homescreen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  var _currentIndex = 0;

  final List<Widget> _children = [
    const HomeScreen(),
    const PortfolioScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10111A),
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFF10111A),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xffFFCF00),
            fontFamily: "Avenir",
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xffFFCF00).withOpacity(0.5),
            fontFamily: "Avenir",
          ),
          backgroundColor: const Color(0xFF10111A),
          selectedItemColor: const Color(0xFFF3AF00),
          unselectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: SizedBox(
                  width: 27, child: Image.asset('assets/images/Home.png')),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                  width: 27, child: Image.asset('assets/images/Wallet.png')),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                  width: 27, child: Image.asset('assets/images/Search.png')),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                  width: 27, child: Image.asset('assets/images/Report.png')),
              label: 'Picks',
            ),
          ],
        ),
      ),
    );
  }
}
