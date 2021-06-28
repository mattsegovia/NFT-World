import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nft_wrld/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:nft_wrld/models/EventNFT.dart';
import 'dart:convert';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  String baseURL = 'https://api.opensea.io/api/v1/';
  var _nftList = [];

  @override
  void initState() {
    print('init run');

    super.initState();
    getCollectionsData().then((value) => {
      if (mounted) setState(() => {
        _nftList.addAll(value),
      })
    });
  }

  Future<List> getCollectionsData() async {
    List NFTList = [];

    var url = Uri.parse(baseURL + 'events?only_opensea=false&offset=0&limit=20');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final assetEvents = responseBody["asset_events"];
      // print(collections);
      for(var i = 0; i< assetEvents.length; i++) {
        var title = assetEvents[i]["asset"]["name"];
        var imgUrl = assetEvents[i]["asset"]["image_url"];
        var permalink = assetEvents[i]["asset"]["permalink"];
        var priceUSD;
        var priceETH;
        if (title  == null || title == "") {
          title = "N/A";
        }
        if (assetEvents[i]["payment_token"]["usd_price"] == null || priceUSD == "" || priceUSD == []) {
          priceUSD = "N/A";
        } else {
          priceUSD = assetEvents[i]["payment_token"]["usd_price"];
          priceUSD = double.parse(priceUSD).toStringAsFixed(2);
        }
        if (assetEvents[i]["payment_token"]["eth_price"] == null || priceETH == "" || priceETH == []) {
          priceETH = "N/A";
        } else {
          priceETH = assetEvents[i]["payment_token"]["eth_price"];
          priceETH = double.parse(priceETH).toStringAsFixed(2);
        }
        if (imgUrl == null || imgUrl.contains('.mp4') || imgUrl.contains('.svg')) {
          imgUrl = "https://t3.ftcdn.net/jpg/04/24/48/50/360_F_424485038_Nuts0TtEXpV0XhquEIOcqdn1XQeb63ZK.jpg";
        }
        if ((imgUrl != null && imgUrl.length > 1) && (priceUSD != null && priceETH != null)) {
          NFTList.add(EventNFT(title, imgUrl, permalink, priceUSD, priceETH));
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> nftCollections = _nftList
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
                      child: Column(
                        children: [
                          Text(
                            '${item.title}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${item.priceUSD} | ${item.priceETH}ETH',
                            style: TextStyle(
                              color: Colors.lightGreenAccent,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
              padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
              child: Row(children: [
                Text('Offers',
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
              child: Column(children: nftCollections),
            ),
          ]
      ),
    );
  }
}