import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './auth_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.primary,
      bottomNavigationBar: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffDDDDEA),
        ),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: TextButton(
          child: const Text(
            'Get Start',
            style: TextStyle(color: Color(0xff000046), fontSize: 13),
          ),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('showHome', true);
            Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            //Provider.of<Auth>(context, listen: false).checker();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          height: mediaQuery.size.height - mediaQuery.padding.top - kBottomNavigationBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.secondary,
                theme.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [
                0,
                0.6
              ],
            ),
          ),
          child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/start.png',
              fit: BoxFit.cover,
              //scale: 2.5,
            ),
            const SizedBox(height: 60),
            Row(children: [
              const Text(
                'Share some cash',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 33.2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 5),
              SizedBox(
                  height: 30,
                  child: Image.asset(
                    'assets/images/emoji.png',
                    fit: BoxFit.cover,
                    scale: 0.1,
                  ))
            ]),
            const Text(
              'with friends',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 33.2,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Send and receive money from those around you easily', style: TextStyle(fontSize: 14, color: Colors.white)),
            const SizedBox(height: 20),
          ])),
        ),
      ),
    );
  }
}
