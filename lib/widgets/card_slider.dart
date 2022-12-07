import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

import '../provider/users.dart';

class CardSlider extends StatefulWidget {
  const CardSlider({Key? key}) : super(key: key);
  @override
  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  // final controller = PageController(initialPage: 0);
  // void _signUp() {
  //   controller.nextPage(
  //     duration: const Duration(milliseconds: 700),
  //     curve: Curves.easeInOut,
  //   );
  // }

  int activeIndex = 0;
  final images = [
    'assets/images/second.png',
    'assets/images/first.png',
    'assets/images/third.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: PageView.builder(
            onPageChanged: (index) {
              setState(() {
                activeIndex = index;
              });
              Provider.of<Users>(context, listen: false).setTheme(index);
              print(index);
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              final img = images[index];
              return Image.asset(
                img,
                // fit: BoxFit.fill,
              );
            }),
      ),
      const SizedBox(
        height: 5,
      ),
      AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: images.length,
        effect: const WormEffect(
          spacing: 4.0,
          activeDotColor: Colors.white,
          dotHeight: 7,
          dotColor: Color(0xff55558B),
          dotWidth: 7,
        ),
      ),
    ]);
  }
}
