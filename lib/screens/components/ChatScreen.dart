// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _textEditingController = TextEditingController();
//   final DatabaseReference _database = FirebaseDatabase.instance.reference().child('chat');
//   List<Map<String, dynamic>> _messages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _database.onChildAdded.listen((event) {
//       setState(() {
//         _messages.add(Map<String, dynamic>.from(event.snapshot.value as Map)); // Cast snapshot value to Map
//       });
//     });
//   }
//
//   void _sendMessage() {
//     String messageText = _textEditingController.text.trim();
//     if (messageText.isNotEmpty) {
//       Map<String, dynamic> message = {
//         'text': messageText,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'sender': 'user', // Change this to the user's identifier
//       };
//       _database.push().set(message);
//       _textEditingController.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Group Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 var message = _messages[index];
//                 return ListTile(
//                   title: Text(message['text']),
//                   subtitle: Text(message['sender']),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _textEditingController = TextEditingController();
//   final DatabaseReference _database = FirebaseDatabase.instance.reference().child('chat');
//   List<Map<String, dynamic>> _messages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _database.onChildAdded.listen((event) {
//       setState(() {
//         _messages.add(Map<String, dynamic>.from(event.snapshot.value as Map)); // Cast snapshot value to Map
//       });
//     });
//   }
//
//   void _sendMessage() {
//     String messageText = _textEditingController.text.trim();
//     if (messageText.isNotEmpty) {
//       Map<String, dynamic> message = {
//         'text': messageText,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'sender': 'User', // Change this to the user's identifier
//       };
//       _database.push().set(message);
//       _textEditingController.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Group Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 var message = _messages[index];
//                 bool isCurrentUser = message['sender'] == 'User'; // Check if the message is sent by the current user
//                 TextAlign textAlign = isCurrentUser ? TextAlign.left : TextAlign.right; // Set text alignment
//                 Color? bubbleColor = isCurrentUser ? Colors.grey[300] : Colors.blue[300]; // Set bubble color
//
//                 return Align(
//                   alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                     padding: EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       color: bubbleColor,
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           message['text'],
//                           textAlign: textAlign,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         SizedBox(height: 4.0),
//                         Text(
//                           '${message['sender']} - ${_formatTimestamp(message['timestamp'])}',
//                           textAlign: textAlign,
//                           style: TextStyle(fontSize: 12.0, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatTimestamp(int timestamp) {
//     DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
//     return '${dateTime.hour}:${dateTime.minute}';
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _textEditingController = TextEditingController();
//   final DatabaseReference _database = FirebaseDatabase.instance.reference().child('chat');
//   List<Map<String, dynamic>> _messages = [];
//   late User _currentUser;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//     _database.onChildAdded.listen((event) {
//       setState(() {
//         _messages.add(Map<String, dynamic>.from(event.snapshot.value as Map)); // Cast snapshot value to Map
//       });
//     });
//   }
//
//   void _getCurrentUser() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     _currentUser = auth.currentUser!;
//   }
//
//   void _sendMessage() {
//     String messageText = _textEditingController.text.trim();
//     if (messageText.isNotEmpty) {
//       Map<String, dynamic> message = {
//         'text': messageText,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'sender': _currentUser.displayName, // Use current user's display name
//         'senderPhotoUrl': _currentUser.photoURL, // Use current user's photo URL
//       };
//       _database.push().set(message);
//       _textEditingController.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Group Chat'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 var message = _messages[index];
//                 bool isCurrentUser = message['sender'] == _currentUser.displayName; // Check if the message is sent by the current user
//                 TextAlign textAlign = isCurrentUser ? TextAlign.left : TextAlign.right; // Set text alignment
//                 Color? bubbleColor = isCurrentUser ? Colors.grey[300] : Colors.blue[300]; // Set bubble color
//
//                 return Align(
//                   alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//                     padding: EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       color: bubbleColor,
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           message['text'],
//                           textAlign: textAlign,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         SizedBox(height: 4.0),
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundImage: isCurrentUser ? NetworkImage(_currentUser.photoURL!) : NetworkImage(message['senderPhotoUrl']),
//                             ),
//                             SizedBox(width: 8.0),
//                             Text(
//                               message['sender'],
//                               style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(width: 8.0),
//                             Text(
//                               '- ${_formatTimestamp(message['timestamp'])}',
//                               style: TextStyle(fontSize: 12.0, color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   String _formatTimestamp(int timestamp) {
//     DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
//     return '${dateTime.hour}:${dateTime.minute}';
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.reference().child('chat');
  List<Map<String, dynamic>> _messages = [];
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _database.onChildAdded.listen((event) {
      setState(() {
        _messages.add(Map<String, dynamic>.from(event.snapshot.value as Map));
      });
    });
  }

  void _getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _currentUser = auth.currentUser!;
  }

  void _sendMessage() {
    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      Map<String, dynamic> message = {
        'text': messageText,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sender': _currentUser.displayName ?? 'Unknown User',
        'senderPhotoUrl': _currentUser.photoURL ?? '',
      };
      _database.push().set(message);
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isCurrentUser = message['sender'] == _currentUser.displayName;
                TextAlign textAlign = isCurrentUser ? TextAlign.left : TextAlign.right;
                Color? bubbleColor = isCurrentUser ? Colors.grey[300] : Colors.blue[300];

                return Align(
                  alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text'] ?? '',
                          textAlign: textAlign,
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: isCurrentUser ? NetworkImage(_currentUser.photoURL ?? '') : NetworkImage(message['senderPhotoUrl'] ?? ''),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              message['sender'] ?? 'Unknown User',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '- ${_formatTimestamp(message['timestamp'] as int)}',
                              style: TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.hour}:${dateTime.minute}';
  }
}

