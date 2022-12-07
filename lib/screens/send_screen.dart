import 'package:flutter/material.dart';

import './my_home_screen.dart';

class SendScreen extends StatefulWidget {
  static const routeName = './send-route-name';
  const SendScreen({Key? key}) : super(key: key);
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  var _loadedInitData = false;
  var _amount = '';
  var _imageUrl = '';
  var _name = '';
  var _select = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      _amount = routeArgs['amount'] as String;
      _imageUrl = routeArgs['imageUrl'] as String;
      _name = routeArgs['name'] as String;
      print('route');
    }
    _loadedInitData = true;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themee = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: mediaQuery.size.height - mediaQuery.padding.top,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              if (_select == 1)
                const Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Color(0xff699BF7),
                ),
              if (_select == 1) const SizedBox(height: 10),
              if (_select == 1)
                const Text(
                  'Successful',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              if (_select == 1) const SizedBox(height: 20),
              if (_select == 1)
                SizedBox(
                    height: 40,
                    width: 80,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            )),
                        child: const Text('Back', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomeScreen()), (Route<dynamic> route) => route.isFirst);
                        })),
              if (_select == 0)
                Text('Send \$$_amount to $_name',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              if (_select == 0) const SizedBox(height: 40),
              if (_select == 0)
                Stack(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[50],
                        backgroundImage: const AssetImage('assets/images/profile.png'),
                        radius: 40,
                      ),
                      const Expanded(
                          child: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          '- - - - - - - - -',
                        ),
                      )),
                      CircleAvatar(
                        backgroundColor: Colors.grey[50],
                        backgroundImage: AssetImage(_imageUrl),
                        radius: 40,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        height: 80,
                        width: 60,
                        // margin: const EdgeInsets.only(top: 15),
                        color: Colors.grey[50],
                        child: Image.asset(
                          'assets/images/bag.png',
                          fit: BoxFit.cover,
                          //scale: 2.5,
                        )),
                  ),
                ]),
              if (_select == 0) const SizedBox(height: 40),
              if (_select == 0)
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Spacer(),
                    SizedBox(
                        height: 40,
                        width: 80,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                )),
                            child: const Text('Yes', style: TextStyle(fontSize: 16)),
                            onPressed: () {
                              setState(() {
                                _select = 1;
                              });
                            })),
                    SizedBox(
                        height: 40,
                        width: 80,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                )),
                            child: const Text('No', style: TextStyle(color: Colors.black, fontSize: 16)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })),
                    const Spacer(),
                  ],
                )
            ]))),
      ),
    );
  }
}
