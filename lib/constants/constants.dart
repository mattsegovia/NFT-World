import 'package:flutter/material.dart';

class Constants {
  // Upper Level Design
  static const Image APP_LOGO = Image(image: AssetImage('assets/Logo1.png'));
  static const EdgeInsets APP_LOGO_MARGIN = EdgeInsets.fromLTRB(40, 70, 40, 25);
  static const Color APP_MAIN_BG_COLOR = Colors.white;
  static const Color APP_BODY_BG_COLOR = Colors.white;
  static const Color APP_NAV_BG_COLOR = Colors.white;
  static const int APP_HEADER_FLEX = 13;
  static const int APP_BODY_FLEX = 70;
  static const int APP_NAV_FLEX = 7;
  static const Image API_LOGO = Image(image: AssetImage('assets/opensea-logo-full-colored-blue.png'));

  // Nav Bar Flex Settings
  static const Color APP_NAV_COLOR_SELECT_ACTIVE = Colors.teal;
  static const Color APP_NAV_COLOR_SELECT_INACTIVE = Colors.black;
  static const int APP_NAV_FLEX_HOME = 25;
  static const int APP_NAV_FLEX_SEARCH = 25;
  static const int APP_NAV_FLEX_PORTFOLIO = 25;
  static const int APP_NAV_FLEX_ACCOUNT = 25;


}