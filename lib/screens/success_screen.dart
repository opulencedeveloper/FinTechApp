import 'package:flutter/material.dart';

import "./my_home_screen.dart";

class SuccessScreen extends StatefulWidget {
  static const routeName = './sigup-success-route';
  const SuccessScreen({Key? key}) : super(key: key);
  @override
  SuccessScreenState createState() => SuccessScreenState();
}

class SuccessScreenState extends State<SuccessScreen> {
  var _loadedInitData = false;
  var _value = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      _value = ModalRoute.of(context)!.settings.arguments.toString();
      print('route');
    }
    _loadedInitData = true;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        color: theme.primary,
        height: 50,
        child: TextButton(
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomeScreen()), (Route<dynamic> route) => route.isFirst);
            Navigator.of(context).pushNamed(MyHomeScreen.routeName);
//            MaterialPageRoute(builder: (context) => TabsScreen()),  (Route<dynamic> route) => route.isFirst);
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          height: mediaQuery.size.height - mediaQuery.padding.top - kBottomNavigationBarHeight,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.03),
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              SizedBox(
                height: (mediaQuery.size.height - mediaQuery.padding.top - kBottomNavigationBarHeight) * 0.3,
              ),
              Image.asset(
                'assets/images/badge.png',
                fit: BoxFit.cover,
                scale: 1,
              ),
              const SizedBox(height: 15),
              const Text(
                'Success',
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 15),
              Text(
                'Your account was $_value successfully',
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
