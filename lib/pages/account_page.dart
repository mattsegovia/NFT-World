import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nft_wrld/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:nft_wrld/models/NFT.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
        if (title  == null || title == "") {
          title = "N/A";
        }
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

  void onPressed() {

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
                Text('Account',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Text('API Credits'),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 0),
              child: Constants.API_LOGO,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
              child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text('Log Out', style: TextStyle(
                      color: Colors.red
                  )),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
            ),


          ]
      ),
    );
  }
}