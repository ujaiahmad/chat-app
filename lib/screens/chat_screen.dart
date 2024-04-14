import 'package:chat_app/constants.dart';
import 'package:chat_app/screens/customMessageCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final controllerText = TextEditingController();
  // late final messageStream;
  late User loggedInUser;
  late String messageText;

  @override
  void initState() {
    // TODO: implement initState
    // final now = DateTime.now();
    // print(now);
    super.initState();
    getCurrentUser();
    // messagesStream();
    // getMessages();
  }

  void getCurrentUser() async {
    // await Firebase.initializeApp();
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<void> messagesStream() async {
  //   messageStream = _firestore.collection('messages').orderBy('timestamp').snapshots();
  //   // await for (var snapshot in messageStream) {
  //   //   for (var message in snapshot.docs) {
  //   //     print(message.data());
  //   //   }
  //   // }
  //   // await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //   //   for (var message in snapshot.docs) {
  //   //     print(message.data());
  //   //   }
  //   // }
  // }

  // Future<void> getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   // messages.docs;
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: Image.asset('images/chat.png'),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // getMessages();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;
                  List<Widget> messageSenderList = [];
                  for (var message in messages) {
                    String messageText = message.data()['text'];
                    String messageSender = message.data()['sender'];
                    Timestamp messageTime = message.data()['timestamp'];
                    // messageInfo.add(message.data()['Text']);
                    // return Text(message.data()['text']);

                    if (messageSender == loggedInUser.email) {
                      final messageWidget = CustomMessageCard(
                          mainAxisAlignmentRow: MainAxisAlignment.end,
                          crossAxisAlignmentColumn: CrossAxisAlignment.end,
                          roundedRectangleBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(17),
                                  bottomRight: Radius.circular(17),
                                  topLeft: Radius.circular(17))),
                          cardColour: Colors.lightBlueAccent,
                          textColour: Colors.white,
                          messageTime: messageTime,
                          messageSender: messageSender,
                          messageText: messageText);
                      messageSenderList.add(messageWidget);
                    } else {
                      final messageWidget = CustomMessageCard(
                        mainAxisAlignmentRow: MainAxisAlignment.start,
                        messageSender: messageSender,
                        messageText: messageText,
                        messageTime: messageTime,
                        textColour: Color.fromARGB(188, 0, 0, 0),
                        cardColour: Colors.lightGreenAccent,
                        crossAxisAlignmentColumn: CrossAxisAlignment.start,
                        roundedRectangleBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(17),
                          bottomRight: Radius.circular(17),
                          topRight: Radius.circular(17),
                        )),
                      );

                      messageSenderList.add(messageWidget);
                    }
                  }
                  return Expanded(
                    child: ListView.builder(
                      // shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return messageSenderList[index];
                      },
                      itemCount: messageSenderList.length,
                    ),
                  );
                  // Column(
                  //   children: messageSenderList,
                  // );
                  // return Text(messages.docs);
                } else {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'No messages...',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controllerText,
                      // onSubmitted: (value) {

                      // },
                      // onChanged: (value) {
                      //   messageText = value;
                      //   //Do something with the user input.
                      // },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageText = controllerText.text;
                      //Implement send functionality.
                      _firestore.collection('messages').add({
                        'sender': loggedInUser.email,
                        'text': messageText,
                        'timestamp': DateTime.now()
                      });
                      controllerText.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
