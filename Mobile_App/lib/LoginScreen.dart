import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory/firebase_options.dart';
import 'package:flutter/src/painting/border_radius.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:flutter/src/widgets/text.dart';
import 'dart:developer' as devtools show log;
import "package:inventory/forgetpassword.dart";
import 'package:inventory/BottomNavigationBar.dart';
import 'package:inventory/showDialog.dart';
import 'package:go_router/go_router.dart';

import 'register.dart';

// import 'Forget_Password_Page.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  void initstate() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
              ),
              Text('Hello, Dear',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Image.asset(
            "assets/images/login.png",
            height: MediaQuery.of(context).size.height * .342,
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: MediaQuery.of(context).size.height * .5,
            decoration: BoxDecoration(
                color: Color.fromRGBO(107, 59, 225, .85),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18))),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Color.fromRGBO(107, 10, 225, 1),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(252, 252, 252, .7),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      hintText: 'Enter your Email Here',
                      hintStyle: const TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  cursorColor: Color.fromRGBO(107, 10, 225, 1),
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: Colors.white,
                    ),
                    suffixIcon: Icon(
                      Icons.disabled_visible,
                      color: Colors.white,
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(252, 252, 252, .7),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    hintText: 'Enter your Password Here',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintStyle: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ForgetPasswordPage();
                          }));
                        },
                        child: Text('Forgot password?',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(107, 59, 225, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        )),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email, password: password);
                        final user = FirebaseAuth.instance.currentUser;
                        if (user?.emailVerified ?? false) {
                          GoRouter.of(context).go('/home');
                        } else {
                          await showErrorDialog(
                              context, 'Go to your Email and verify.');
                        }
                      } on FirebaseAuthException catch (e) {
                        print("*********** ${e.code}");
                        if (e.code == 'user-not-found') {
                          await showErrorDialog(context, 'User Not Found');
                        } else if (e.code == 'wrong-password') {
                          print("********* ${e.code}");
                          await showErrorDialog(
                              context, 'Wrong password Entered');
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 19,
                ),
                Row(
                  children: [
                    Text(
                      "Don't Have an Account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 74,
                    ),
                    TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(107, 59, 225, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterView()));
                      },
                      child: Text(
                        'Sign Up!!',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    ));
  }
}
