// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/register_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 80,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "ChatApp",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "LOGIN and CHAT with your friends",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Image.asset('assets/main.png'),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.blue,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                            print(email);
                          });
                        },
                        validator: (value) {
                          return RegExp(
                                      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(value!)
                              ? null
                              : "Enter a valid email";
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                            print(password);
                          });
                        },
                        validator: (value) {
                          return value!.length > 6
                              ? null
                              : "Enter a password 6+ chars long";
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            login();
                          },
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: "Sign UP? ",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const RegisterPage());
                                  }),
                          ],
                          text: "Don't have an account? ",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.login(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(snapshot.docs[0]['fullName']);
          nextScreenReplace(context, const HomeScreen());
        } else {
          showSnackBar(context, Colors.blue, value);

          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
