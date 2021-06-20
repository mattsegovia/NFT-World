import 'package:flutter/material.dart';
import 'package:nft_wrld/constants/constants.dart';
import 'package:nft_wrld/pages/account_page.dart';
import 'package:nft_wrld/pages/home_page.dart';
import 'package:nft_wrld/pages/search_page.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  void _goToHome(){
    Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomePage()),);
  }

  void _goToSearch(){
    Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => SearchPage()),);
  }

  void _goToAccount(){
    Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => AccountPage()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.APP_MAIN_BG_COLOR,
      body: Center(
        child: Column(
          children: [
            Expanded(
                flex: Constants.APP_HEADER_FLEX,
                child: Container(
                  margin: Constants.APP_LOGO_MARGIN,
                  alignment: Alignment.bottomCenter,
                  // color: Constants.APP_HEADER_BG_COLOR,
                  child: Constants.APP_LOGO,
                )
            ),
            Expanded(
                flex: Constants.APP_BODY_FLEX,
                child: Container(
                  alignment: Alignment.center,
                  color: Constants.APP_BODY_BG_COLOR,
                  child: Text('Portfolio Page'),
                )
            ),
            Expanded(
                flex: Constants.APP_NAV_FLEX,
                child: Container(
                  color: Constants.APP_NAV_BG_COLOR,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: Constants.APP_NAV_FLEX_HOME,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.home, color: Constants.APP_NAV_COLOR_SELECT_INACTIVE),
                            tooltip: 'Home',
                            onPressed: () {
                              _goToHome();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: Constants.APP_NAV_FLEX_SEARCH,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.search, color: Constants.APP_NAV_COLOR_SELECT_INACTIVE),
                            tooltip: 'Search',
                            onPressed: () {
                              _goToSearch();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: Constants.APP_NAV_FLEX_PORTFOLIO,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.show_chart, color: Constants.APP_NAV_COLOR_SELECT_ACTIVE),
                            tooltip: 'Portfolio',
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: Constants.APP_NAV_FLEX_ACCOUNT,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(Icons.account_circle, color: Constants.APP_NAV_COLOR_SELECT_INACTIVE),
                            tooltip: 'Account',
                            onPressed: () {
                              _goToAccount();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
