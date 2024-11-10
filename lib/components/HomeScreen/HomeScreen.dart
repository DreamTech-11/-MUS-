import 'package:flutter/material.dart';
import '../CalenderScreen/calenderScreen.dart';
import '../DreamCardListScreen/DreamCardListScreen.dart';
import '../SettingScreen/SettingScreen.dart';
import 'NavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screenWidgets = [
      dreamCardListScreen(onItemTapped: onItemTapped),
      CalenderScreen(onItemTapped: onItemTapped),
      SettingScreen(onItemTapped: onItemTapped),
    ];

    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: HomeBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: (index) {
            setState(() {
              _selectedIndex = index;
            });
            },
        ),
        body: Stack(
          children: [
            screenWidgets[_selectedIndex],
          ],
        )
    );
  }
}