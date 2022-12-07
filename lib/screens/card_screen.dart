import 'package:flutter/material.dart';

import './send_screen.dart';

class CardScreen extends StatefulWidget {
  static const routeName = './card-screen-route';
  const CardScreen({Key? key}) : super(key: key);
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  var _loadedInitData = false;
  var _name = '';
  var _imageUrl = '';
  var validate = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      _name = routeArgs['name'] as String;
      _imageUrl = routeArgs['imageUrl'] as String;
      print('route');
    }
    _loadedInitData = true;
  }

  final _controller = TextEditingController();
  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _controller.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    // return null if the text is valid
    return null;
  }

  var index = 0;
  final images = [
    'assets/images/second.png',
    'assets/images/first.png',
    'assets/images/third.png',
  ];
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.primaryColor,
        ),
        height: 50,
        child: TextButton(
          child: const Text(
            'Send',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              validate = 1;
            });
            if (_errorText != null) return;
            print(_controller.value.text);
            Navigator.of(context).pushNamed(
              SendScreen.routeName,
              arguments: {
                'amount': _controller.value.text,
                'imageUrl': _imageUrl,
                'name': _name,
              },
            );
            // Navigator.pushAndRemoveUntil(context,

            //     MaterialPageRoute(builder: (context) => TabsScreen()),

            //     (Route<dynamic> route) => route.isFirst

            // );
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: mediaQuery.size.height - mediaQuery.padding.top,
          width: double.infinity,
          child: SingleChildScrollView(
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox(height: 90, width: double.infinity),
                    CircleAvatar(radius: 36, backgroundImage: AssetImage(_imageUrl)),
                    Positioned(
                        top: 5,
                        left: 0,
                        child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }))
                  ],
                ),
                Text(
                  _name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Choose Card', style: TextStyle(fontSize: 16)),
                    Text(
                        index == 0
                            ? '\$400,000'
                            : index == 1
                                ? '\$600,000'
                                : index == 2
                                    ? '\$800,000'
                                    : '',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                  ]),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    height: 110,
                    padding: const EdgeInsets.only(left: 16),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, i) {
                          return Row(children: [
                            Column(children: [
                              Expanded(
                                child: GestureDetector(
                                    child: Image.asset(
                                      images[i],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        index = i;
                                      });
                                    }),
                              ),
                              index == i
                                  ? const SizedBox(
                                      height: 30,
                                      child: Icon(
                                        Icons.check_circle,
                                        // size: 80,
                                        color: Colors.green,
                                      ))
                                  : const SizedBox(
                                      height: 30,
                                    ),
                            ]),
                            const SizedBox(
                              width: 10,
                            )
                          ]);
                        })),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'Enter Amount',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 55,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(children: [
                    Container(
                      width: mediaQuery.size.width * 0.25,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1, color: Colors.grey),
                        ),
                      ),
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9),
                          height: 10,
                          child: Row(children: [
                            Expanded(
                                child: Image.asset(
                              'assets/images/flag.png',
                              fit: BoxFit.fill,
                              scale: 0.1,
                            )),
                            const SizedBox(width: 5),
                            const Expanded(child: Text('USD'))
                          ])),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          //enabled: false,
                          //focusNode: new AlwaysDisabledFocusNode(),
                          //autofocus: false,
                          decoration: InputDecoration(
                            errorText: validate == 0 ? null : _errorText,
                            labelText: 'Please Enter Amount',

                            border: InputBorder.none,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                            //filled: true,
                            // fillColor: Colors.grey[200],
                          ),

                          // onChanged: (val) => amountInput = val,
                        ),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'Comment (optional)',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const TextField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 5,
                    //enabled: false,
                    //focusNode: new AlwaysDisabledFocusNode(),
                    //autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Comment',
                      border: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      //filled: true,
                      // fillColor: Colors.grey[200],
                    ),

                    // onChanged: (val) => amountInput = val,
                  ),
                )
              ])),
        ),
      ),
    );
  }
}
