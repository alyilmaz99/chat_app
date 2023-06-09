import 'package:chat_app/service/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool haveUserSearched = false;
  String username = "";

  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }

  getCurrentUserIdandName() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search Groups...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    initStateSearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : groupList(),
        ],
      ),
    );
  }

  initStateSearchMethod() async {
    if (searchController.text.isEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          isLoading = false;
          searchSnapshot = snapshot;
          haveUserSearched = true;
          groupList();
        });
      });
    }
  }

  groupList() {
    /*
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                searchSnapshot!.docs[index]["groupId"],
                searchSnapshot!.docs[index]["groupName"],
                searchSnapshot!.docs[index]["groupAdmin"],

              );
            },
          )
        : Container();
 
 */
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    return Text('Hello');
  }
}
