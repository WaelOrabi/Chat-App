import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _fireStore = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static const chatScreen = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? messageText;
  final messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMasseges()async{
  //  final messages=await _fireStore.collection('messages').get();
  //  messages.docs.forEach((message) {
  //    print(message.data()['text']);
  //  });
  // }
  void getMessage() async {
    // await _fireStore.collection('messages').snapshots().listen((event) {
    //   event.docs.forEach((messages) {
    //     print(messages.data()['text']);
    //     print(messages.data()['sender']);
    //   });
    // });
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.blueAccent,
            )),
        backgroundColor: Colors.white,
        elevation: 5,
        title: Row(
          children: [
            Image.asset(
              'assets/images/messenger.png',
              height: 25,
            ),
            const SizedBox(
              width: 10,
            ),
             Expanded(
               child: Text('${signedInUser.email}',style: const TextStyle(
                 color: Colors.blue,
               ),),
             ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut().then((value) => Navigator.pop(context));
              },
              icon: const Icon(
                Icons.close,
                color: Colors.blueAccent,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: Colors.blue,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MessageStreamBuilder(),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.blueAccent, width: 2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    onChanged: (value) {
                      messageText = value;
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      hintText: 'write your message here...',
                      border: InputBorder.none,
                    ),
                  )),
                  TextButton(
                      onPressed: () async {
                        messageController.clear();
                        await _fireStore.collection('messages').add({
                          'text': messageText,
                          'sender': signedInUser.email,
                          'time': FieldValue.serverTimestamp(),
                        });
                      },
                      child: Text(
                        'send',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _fireStore.collection('messages').orderBy('time').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<MessageLine> messageWidgets = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = signedInUser.email;
            final messageWidget = MessageLine(
                text: messageText,
                sender: messageSender,
                isMe: currentUser == messageSender ? true : false);

            messageWidgets.add(messageWidget);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
            ),
          );
        });
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine(
      {required this.text, required this.sender, required this.isMe, Key? key})
      : super(key: key);
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.yellow[900],
              fontSize: 12,
            ),
          ),
          Material(
            elevation: 5,
            color: isMe ? Colors.blue[800] : Colors.white,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
