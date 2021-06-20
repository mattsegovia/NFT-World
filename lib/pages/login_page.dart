import 'package:flutter/material.dart';
import 'package:nft_wrld/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _goToHome(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 60,
              child: Container(
                alignment: Alignment.center,
                child: Text('Logo Image')
            )),
            Expanded(
              flex: 40,
              child: Container(
                alignment: Alignment.topCenter,
                child: ElevatedButton(onPressed: _goToHome, child: Text('Login'))
              )),
          ],
        ),
      ),
    );
  }
}
