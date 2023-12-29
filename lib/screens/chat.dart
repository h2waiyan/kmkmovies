import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moviesdb/screens/login.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  List mymessages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessages();
  }

  getMessages() async {
    await for (var snapshot
        in FirebaseFirestore.instance.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
        mymessages.add(message.data());
      }
      setState(() {});
    }
    // var messageSnapShots =
    //     await FirebaseFirestore.instance.collection('messages').snapshots(); // LIST
    // setState(() {
    //   for (var snapshot in messageSnapShots.docs) {

    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          actions: [
            IconButton(
                onPressed: () {
                  getMessages();
                },
                icon: const Icon(Icons.refresh)),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: mymessages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${mymessages[index]['sender']}"),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("${mymessages[index]['message']}"),
                          ),
                        )
                      ],
                    );
                  }),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Message',
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('messages')
                        .add({
                      'sender': FirebaseAuth.instance.currentUser?.email,
                      'message': messageController.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                  },
                  child: const Text("Send Message"))
            ],
          ),
        ));
  }
}
