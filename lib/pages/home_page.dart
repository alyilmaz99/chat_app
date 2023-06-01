import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  String userName = '';
  String email = '';
  Stream? groups;
  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        email = value;
      });
    });
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        userName = value;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups(email)
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                const SearchPage(),
              );
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "ChatApp",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            const Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.blueGrey,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(
                Icons.groups,
                color: Colors.blue,
              ),
              title: const Center(
                child: Text(
                  "Groups",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreen(
                  context,
                  ProfilePage(
                    email: email,
                    userName: userName,
                  ),
                );
              },
              selectedColor: Colors.blue,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: const Center(
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Logout'),
                        content: const Text('Are you sure to exit?'),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              authService.signOut().whenComplete(
                                () {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return const LoginPage();
                                    },
                                  ), (route) => false);
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.blue,
              ),
              title: const Center(
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popupDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  popupDialog(BuildContext context) {}

  groupList() {}
}
