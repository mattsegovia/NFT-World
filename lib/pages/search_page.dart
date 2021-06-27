import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nft_wrld/constants/constants.dart';
import 'package:nft_wrld/pages/account_page.dart';
import 'package:nft_wrld/pages/home_page.dart';
import 'package:nft_wrld/pages/portfolio_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:nft_wrld/models/NFT.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}



class _SearchPageState extends State<SearchPage> {
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

    var url = Uri.parse(baseURL + 'collections?offset=0&limit=10');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final collections = responseBody["collections"];
      // print(collections);
      for(var i = 0; i< collections.length; i++) {
        var title = collections[i]["name"];
        var imgUrl = collections[i]["image_url"];
        var permalink = "https://opensea.io/collection/" + collections[i]["slug"];
        // print(imgUrl);
        if (imgUrl == null || imgUrl.contains('.mp4') || imgUrl.contains('.svg')) {
          imgUrl = "https://t3.ftcdn.net/jpg/04/24/48/50/360_F_424485038_Nuts0TtEXpV0XhquEIOcqdn1XQeb63ZK.jpg";
        }
        if(imgUrl != null && imgUrl.length > 1) {
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
                padding: EdgeInsets.fromLTRB(40, 20, 40, 10),
                child: Row(children: [
                  Text('Collections',
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
