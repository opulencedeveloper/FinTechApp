import 'dart:math';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

import '../widgets/card_slider.dart';
import '../screens/auth_screen.dart';
import '../widgets/recent_transactions.dart';
import '../provider/users.dart';
import '../provider/auth.dart';
import './card_screen.dart';

class MyHomeScreen extends StatefulWidget {
  static const routeName = 'home-route';
  const MyHomeScreen({Key? key}) : super(key: key);
  @override
  // AllFoodTabState createState() => AllFoodTabState();
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  //""async await" wasnt used here because we are overwriting this

  //method and this method doesnt

  // return a future so we used a then block"

  //but you already know there is another way to manage the loading

  //spinner

  Future<dynamic>? _allUsersFuture;

  Future _obtainAllUsersFuture() {
    return Provider.of<Users>(context, listen: false).fetchAndSetUsers();
  }

  @override
  void initState() {
    super.initState();
    _allUsersFuture = _obtainAllUsersFuture();
    Provider.of<Auth>(context, listen: false).fetchAndSetUserName();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context).colorScheme;
    final userColor = Provider.of<Users>(context);
    final pickedColor = userColor.selectedTheme;
    String? userName = Provider.of<Auth>(context).userNameGet;
    final userData = Provider.of<Users>(context, listen: false);
    final user = userData.user;
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: mediaQuery.size.height - mediaQuery.padding.top,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  pickedColor == 0
                      ? theme.secondary
                      : pickedColor == 1
                          ? const Color(0xff200121)
                          : const Color(0xff0F2027),
                  pickedColor == 0
                      ? theme.primary
                      : pickedColor == 1
                          ? const Color(0xff1C0001)
                          : const Color(0xff06131B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [
                  0,
                  0.5
                ],
              ),
            ),
            child: FutureBuilder(
                future: _allUsersFuture,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ));
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        //
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 70,
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 26,
                                  backgroundImage: AssetImage('assets/images/profile.png'),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 45,
                                  width: mediaQuery.size.width * 0.46,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                          child: const Text(
                                            'Welcome back',
                                            style: TextStyle(color: Colors.white, fontSize: 13),
                                          ),
                                          onTap: () {
                                            Provider.of<Auth>(context, listen: false).logout();
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthScreen()));
                                          }),
                                      Text(
                                        userName.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          //FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 40,
                                  width: 50,
                                  child: Badge(
                                    animationType: BadgeAnimationType.fade,
                                    padding: const EdgeInsets.all(4),
                                    //toAnimate: false,
                                    badgeContent: const Text("0", style: TextStyle(fontSize: 10)),
                                    badgeColor: Colors.white,
                                    position: BadgePosition.topEnd(top: 3, end: 5),
                                    child: const Icon(Icons.notifications_outlined, size: 40, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                  height: 50,
                                  child: Icon(Icons.dehaze, color: Colors.white, size: 40),
                                ),
                              ],
                            ),
                          ),
                          //  const SizedBox(height: 10),
                          Container(height: 230, padding: const EdgeInsets.symmetric(horizontal: 15), width: double.infinity, child: CardSlider()),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            height: 70,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 15),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                                    Text(
                                      'Income',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '\$400,046.00',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                  ]),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0.2, //                   <--- border width here
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          pickedColor == 0
                                              ? const Color(0xff55558B)
                                              : pickedColor == 1
                                                  ? const Color(0xff6C576A)
                                                  : const Color(0xff5C666B),
                                          pickedColor == 0
                                              ? const Color(0xff35367C)
                                              : pickedColor == 1
                                                  ? const Color(0xff4B353D)
                                                  : const Color(0xff3A454B),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: const [
                                          0,
                                          0.5
                                        ],
                                      )),
                                )), ///////////
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Container(
                                  padding: const EdgeInsets.only(left: 15, top: 10, bottom: 15),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                                    Text(
                                      'Expenses',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '\$20,000',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                                    ),
                                  ]),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0.2, //                   <--- border width here
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          pickedColor == 0
                                              ? const Color(0xff55558B)
                                              : pickedColor == 1
                                                  ? const Color(0xff6C576A)
                                                  : const Color(0xff5C666B),
                                          pickedColor == 0
                                              ? const Color(0xff35367C)
                                              : pickedColor == 1
                                                  ? const Color(0xff4B353D)
                                                  : const Color(0xff3A454B),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        stops: const [
                                          0,
                                          0.5
                                        ],
                                      )),
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: pickedColor == 0
                                              ? const Color(0xff1CB5DF)
                                              : pickedColor == 1
                                                  ? const Color(0xff6E0000)
                                                  : const Color(0xff1D4350),
                                        ),
                                        child: Transform.rotate(
                                          angle: 100 * pi / 57,
                                          child: const Icon(Icons.send, color: Colors.white, size: 30),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Transfer',
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ]),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )),
                                const SizedBox(width: 13),
                                Expanded(
                                    child: Container(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: pickedColor == 0
                                              ? const Color(0xff1CB5DF)
                                              : pickedColor == 1
                                                  ? const Color(0xff6E0000)
                                                  : const Color(0xff1D4350),
                                        ),
                                        child: const Icon(Icons.attach_money, color: Colors.white, size: 35),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Airtime',
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ]),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )), /////.....................
                                const SizedBox(width: 13),
                                Expanded(
                                    child: Container(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: pickedColor == 0
                                              ? const Color(0xff1CB5DF)
                                              : pickedColor == 1
                                                  ? const Color(0xff6E0000)
                                                  : const Color(0xff1D4350),
                                        ),
                                        child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 30),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Scan',
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ]),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )),
                                const SizedBox(width: 13), //////
                                Expanded(
                                    child: Container(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: pickedColor == 0
                                              ? const Color(0xff1CB5DF)
                                              : pickedColor == 1
                                                  ? const Color(0xff6E0000)
                                                  : const Color(0xff1D4350),
                                        ),
                                        child: const Icon(Icons.more_horiz_sharp, color: Colors.white, size: 40),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'More',
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ]),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 35),
                          const Text(
                            'Send Money',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: user.length,
                              itemBuilder: (context, i) => Row(children: [
                                Column(children: [
                                  DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(30),
                                      dashPattern: const [
                                        10,
                                        10
                                      ],
                                      color: i == 0 ? Colors.white : Colors.white.withOpacity(0),
                                      strokeWidth: 2,
                                      child: GestureDetector(
                                          child: CircleAvatar(
                                            backgroundColor: const Color(0xff000046),
                                            backgroundImage: i == 0 ? null : AssetImage(user[i].imageUrl),
                                            child: i == 0 ? const Icon(Icons.search, size: 50, color: Colors.white) : Container(),
                                            radius: 30,
                                          ),
                                          onTap: () {
                                            if (i == 0) return;
                                            Navigator.of(context).pushNamed(
                                              CardScreen.routeName,
                                              arguments: {
                                                'name': user[i].name,
                                                'imageUrl': user[i].imageUrl,
                                              },
                                            );
                                          })),
                                  Text(i == 0 ? '' : user[i].firstName, style: const TextStyle(color: Colors.white)),
                                ]),
                                const SizedBox(width: 8),
                              ]),
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            'Recent Transactions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const RecentTransactions()
                        ]),
                      );
                    }
                  }
                })),
      ),
    );
  }
}
