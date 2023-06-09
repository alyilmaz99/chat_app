import 'package:chat_app/pages/group_info.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String username;
  const ChatPage({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.username,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getChats(widget.groupId)
        .then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupAdmin(widget.groupId)
        .then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                  context,
                  GroupInfo(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: admin,
                  ));
            },
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          widget.groupName,
        ),
      ),
    );
  }
}
