import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/users.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Users>(context);
    final user = userData.user;
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.5,
      child: SingleChildScrollView(
        child: Column(
          children: user
              .map((data) => ListTile(
                  horizontalTitleGap: 5,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(data.imageUrl),
                    radius: 30,
                  ),
                  title: Text(
                    data.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    data.date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  trailing: Text(
                    '\$${data.amount}.00',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )))
              .toList(),
        ),
      ),
    );
  }
}
