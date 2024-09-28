import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:demo/presentation/pages/home_page/home_screen.dart';
import 'package:demo/presentation/pages/home_screen_tab/home_screen_tab.dart';
import 'package:demo/presentation/pages/payment_done_screen/decline_screen.dart';
import 'package:demo/presentation/pages/payment_done_screen/payment_done-screen.dart';

class BottomNav extends StatefulWidget {
  BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Widget> screens = [
     HomeScreenTabBar(),
    const PaymentDoneScreen(),
    const DeclineScreen()
  ];
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: i,
        children: screens,
      ),
      // body: screens[i],
      bottomNavigationBar: GNav(
          tabMargin: EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          gap: 8,
          padding: const EdgeInsets.all(16),
          onTabChange: (value) {
            setState(() {
              i = value;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.payments_rounded,
              text: 'Payment',
            ),
            GButton(
              icon: Icons.error_outline,
              text: 'Decline',
            )
          ]),
    );
  }
}
