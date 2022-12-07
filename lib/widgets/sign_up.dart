import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import "../provider/auth.dart";
import '../screens/success_screen.dart';

class SignUp extends StatefulWidget {
  final VoidCallback signUp;
  const SignUp({Key? key, required this.signUp}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'username': '',
    'password': '',
  };
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    try {
      // Log user in
      await Provider.of<Auth>(context, listen: false).signUp(
        _authData["email"] as String,
        _authData["password"] as String,
      );
      Provider.of<Auth>(context, listen: false).createUsername(
        _authData["username"] as String,
      );
    } on HttpException catch (error) {
//HttpException is from the file u created in the models folder, u caught and passed this exception in the auth.dart file
      var errorMessage = "Authentication failed";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This email address is already in use";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "This is to a valid email address";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "This password is too weak";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Could not find a user with that email";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid password";
      }
      _showErrorDialog(errorMessage);
      setState(() {
        _isLoading = false;
      });
      return;
    } catch (error) {
      const errorMessage = "Could not authenticate you, Please try again later. ";
      _showErrorDialog(errorMessage);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed(SuccessScreen.routeName, arguments: 'created');
//    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomeScreen()), (Route<dynamic> route) => route.isFirst);

    //widget.signIn();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
                title: const Text("An Error Occurerd"),
                content: Text(
                  message,
                ),
                actions: [
                  ElevatedButton(
                      child: const Text("Okay"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      })
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
          const SizedBox(height: 10),
          Align(alignment: Alignment.center, child: Image.asset('assets/images/logo.png')),
          const SizedBox(height: 15),
          const Text('Sign Up',
              //textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 3),
          const Text('Enter your details to create an account with us',
              style: TextStyle(
                fontSize: 13,
              )),
          const SizedBox(height: 30),
          const Text('Email',
              style: TextStyle(
                fontSize: 13,
              )),
          const SizedBox(height: 6),
          SizedBox(
            height: 85,
            child: TextFormField(
              // controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Color(0xffDADADA)),
                ),
                // hintText: 'Mobile Number',
                //labelText: 'Chexk',
                //fillColor: Colors.white,
                //filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['email'] = value as String;
              },
            ),
          ),
          const Text('User name',
              style: TextStyle(
                fontSize: 13,
              )),
          const SizedBox(height: 6),
          SizedBox(
            height: 85,
            child: TextFormField(
              // controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide(color: Color(0xffDADADA)),
                ),
                // hintText: 'Mobile Number',
                //labelText: 'Chexk',
                //fillColor: Colors.white,
                //filled: true,
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty || value.length > 8) {
                  return 'Username should be less than 8 characters!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['username'] = value as String;
              },
            ),
          ),
          const Text('Password',
              style: TextStyle(
                fontSize: 13,
              )),
          const SizedBox(height: 6),
          SizedBox(
              height: 85,
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Color(0xffDADADA)),
                  ),
                  // hintText: 'Mobile Number',
                  //labelText: 'Chexk',
                  //fillColor: Colors.white,
                  //filled: true,
                ),
                // obscureText: obsure.passwordObsureMode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                //controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 4) {
                    return 'Password is too short!';
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value as String;
                },
              )),
          const Text('Confirm Password',
              style: TextStyle(
                fontSize: 13,
              )),
          const SizedBox(height: 6),
          SizedBox(
              height: 95,
              child: TextFormField(
//controller: _confirmpasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Color(0xffDADADA)),
                  ),
                  // hintText: 'Mobile Number',
                  //labelText: 'Chexk',
                  //fillColor: Colors.white,
                  //filled: true,
                ),
                //obscureText: obsure.confirmpasswordObsureMode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
//controller: _passwordController,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match!';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _authData['password'] = value as String;
                },
              )),
          SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ))
                      : const Text('CONTINUE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          )),
                  onPressed: _submit)),
          const SizedBox(height: 40),
          const Align(
              alignment: Alignment.center,
              child: Text('OR',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ))),
          const SizedBox(height: 40),
          Container(
            height: 45,
            padding: const EdgeInsets.only(left: 22, bottom: 5, top: 5, right: 40),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xffDADADA), // Set border color
                //width: 3.0
              ), // Set border width
              borderRadius: const BorderRadius.all(Radius.circular(10.0)), // Make rounded corner of border
            ),
            child: Row(children: [
              Image.asset('assets/images/google.png'),
              const Expanded(
                child: Text('Sign up with Google',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    )),
              )
            ]),
          ),
          const SizedBox(height: 20),
          Container(
            height: 45,
            padding: const EdgeInsets.only(left: 22, bottom: 5, top: 5, right: 40),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xffDADADA), // Set border color
                //width: 3.0
              ), // Set border width
              borderRadius: const BorderRadius.all(Radius.circular(10.0)), // Make rounded corner of border
            ),
            child: Row(children: [
              Image.asset('assets/images/facebook.png'),
              const Expanded(
                child: Text('Sign up with Facebook',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    )),
              )
            ]),
          ),
          const SizedBox(height: 100),
          Container(
            height: 45,
            width: double.infinity,
            child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Already have an account?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  )),
              TextButton(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ))
                    : const Text('Sign in', style: TextStyle(color: Color(0xff1CB5E0))),
                onPressed: widget.signUp,
              ),
            ]),
          )
        ])));
  }
}
