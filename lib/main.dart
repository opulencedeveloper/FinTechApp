import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './screens/my_home_screen.dart';
import './screens/card_screen.dart';
import './screens/send_screen.dart';
import './screens/splash_screen.dart';
import './screens/get_started_screen.dart';
import './screens/auth_screen.dart';
import './screens/success_screen.dart';

import './provider/users.dart';
import './provider/auth.dart';

void main() async {
  print("runApp");
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;
  runApp(MyApp(showHome: showHome));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({Key? key, required this.showHome}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Users>(
          update: (ctx, auth, allFoods) => Users(
            auth.token.toString(),
            allFoods == null ? [] : allFoods.user,
          ),
          create: (ctx) => Users("", []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FinTech',
            theme: ThemeData(
              fontFamily: 'Inter',
              primaryColor: const Color(0xff000046),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color(0xff00007C),
                secondary: const Color(0xff000046),
              ),
            ),
            home: !showHome
                ? const GetStartedScreen()
                : auth.isAuth
                    ? const MyHomeScreen() //const TabsScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState == ConnectionState.waiting ? const SplashScreen() : const AuthScreen(),
                      ), //SignUp(), //MyHomeScreen(),  //SendScreen(), // //CardScreen(),
            routes: {
              CardScreen.routeName: (ctx) => const CardScreen(),
              SendScreen.routeName: (ctx) => const SendScreen(),
              SuccessScreen.routeName: (ctx) => const SuccessScreen(),
              MyHomeScreen.routeName: (ctx) => const MyHomeScreen(),
              AuthScreen.routeName: (ctx) => const AuthScreen(),
            }),
      ),
    );
  }
}
