import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:nft_wrld/constants/constants.dart';
import 'package:nft_wrld/models/NFT.dart';
import 'package:nft_wrld/models/User.dart';
import 'package:nft_wrld/pages/account_page.dart';
import 'package:nft_wrld/pages/portfolio_page.dart';
import 'package:nft_wrld/pages/search_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String baseURL = 'https://api.opensea.io/api/v1/';
  var _featuredImgList = [];
  var _homeImgList = [];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Test',
      style: optionStyle,
    ),
  ];

  Future<List> getFeaturedData() async {
    List NFTList = [];

    var url = Uri.parse(baseURL + 'bundles?on_sale=true&limit=10&offset=0');
    var response = await http.get(url);
    
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final bundles = responseBody["bundles"];

      for(var i = 0; i< bundles.length; i++) {
        // grab first image from each bundle
        var title = bundles[i]["name"];
        var imgUrl = bundles[i]["assets"][0]["image_url"];
        var permalink = bundles[i]["permalink"];
        if (imgUrl.contains('.mp4') || imgUrl.contains('.svg')) {
          imgUrl = bundles[i]["assets"][0]["collection"]["featured_image_url"];
        }
        if(imgUrl != null && imgUrl.length > 1) {
          NFTList.add(NFT(title, imgUrl, permalink));
        }
      }
    }
    return NFTList;
  }

  Future<List> getHomeData() async {
    List NFTList = [];

    var url = Uri.parse(baseURL + 'assets?order_direction=desc&offset=0&limit=20');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final assets = responseBody["assets"];

      for(var i = 0; i< assets.length; i++) {
        var title = assets[i]["name"];
        var imgUrl = assets[i]["image_url"];
        var permalink = assets[i]["permalink"];
        if (imgUrl.contains('.mp4') || imgUrl.contains('.svg')) {
          imgUrl = assets[i]["collection"]["image_url"];
        }
        if(imgUrl != null && imgUrl.length > 1) {
          // add attributes to NFT obj here
          NFTList.add(NFT(title, imgUrl, permalink));
        }
      }
    }
    return NFTList;
  }

  Future<void> _launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToSearch(){
    // var user = new User('test@me.com');
    // print(user.toString());
    Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => SearchPage()),);
  }

  void _goToPortfolio(){
    Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => PortfolioPage()),);
  }

  void _goToAccount(){
    Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => AccountPage()),);
  }
  
  @override
  void initState() {
    getFeaturedData().then((value) => {
      setState(() => {
        _featuredImgList.addAll(value),
      })
    });
    getHomeData().then((value2) => {
      setState(() => {
        _homeImgList.addAll(value2)
      })
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = _featuredImgList
        .map((item) => Container(
      child: GestureDetector(
        onTap: () async => await _launchInWebViewWithJavaScript(item.permalink),
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item.imageURL, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        '${item.title}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    ))
        .toList();

    final List<Widget> imageSliders2 = _homeImgList
        .map((item) => Container(
      child: GestureDetector(
        // go to details page
        onTap: () async => await _launchInWebViewWithJavaScript(item.permalink),
        child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item.imageURL, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        '${item.title}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    ))
        .toList();

    return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: Constants.APP_LOGO_MARGIN,
              alignment: Alignment.bottomCenter,
              child: Constants.APP_LOGO,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: Row(children: [
                Text('Featured',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ]),
            ),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            ),
            Container(
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.blueAccent)
              // ),
              padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
              child: Row(children: [
                Text('NFTs',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ]),
            ),

            Container(
              // decoration: BoxDecoration(
              //     border: Border.all(color: Colors.blueAccent)
              // ),
              // padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
              child: Column(children: imageSliders2),
            ),
          ]
        ),
    );
  }

}
