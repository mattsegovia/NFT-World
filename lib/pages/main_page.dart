import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:nft_wrld/constants/constants.dart';
import 'package:nft_wrld/models/NFT.dart';
import 'package:nft_wrld/models/User.dart';
import 'package:nft_wrld/pages/account_page.dart';
import 'package:nft_wrld/pages/home_page.dart';
import 'package:nft_wrld/pages/portfolio_page.dart';
import 'package:nft_wrld/pages/search_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    PortfolioPage(),
    AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.APP_MAIN_BG_COLOR,
      body: SingleChildScrollView(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Constants.APP_NAV_COLOR_SELECT_INACTIVE),
            activeIcon: Icon(Icons.home, color: Constants.APP_NAV_COLOR_SELECT_ACTIVE),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Constants.APP_NAV_COLOR_SELECT_INACTIVE),
            activeIcon: Icon(Icons.search, color: Constants.APP_NAV_COLOR_SELECT_ACTIVE),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart, color: Constants.APP_NAV_COLOR_SELECT_INACTIVE),
            activeIcon: Icon(Icons.show_chart, color: Constants.APP_NAV_COLOR_SELECT_ACTIVE),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Constants.APP_NAV_COLOR_SELECT_INACTIVE),
            activeIcon: Icon(Icons.account_circle, color: Constants.APP_NAV_COLOR_SELECT_ACTIVE),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }

}
