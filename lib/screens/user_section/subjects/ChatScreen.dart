import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';  // Import the intl package for date formatting

class ChatScreen extends StatefulWidget {
  final String id;

  ChatScreen(this.id);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String _id;
  final TextEditingController _textEditingController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> _messages = [];
  late User _currentUser;
  bool _showEmojiPicker = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _getCurrentUser();
    _database.child(getChatroomID(_id)).onChildAdded.listen((event) {
      setState(() {
        _messages.add(Map<String, dynamic>.from(event.snapshot.value as Map));
      });
      _scrollToBottom();
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
      _database.child(getChatroomID(_id)).push().set(message).then((_) {
        _scrollToBottom();
      });
      _textEditingController.clear();
    }
  }

  void _sendImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Reference ref = FirebaseStorage.instance.ref().child('chat_images').child(DateTime.now().millisecondsSinceEpoch.toString());
      UploadTask uploadTask = ref.putFile(File(pickedFile.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> message = {
        'image': downloadUrl,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sender': _currentUser.displayName ?? 'Unknown User',
        'senderPhotoUrl': _currentUser.photoURL ?? '',
      };
      _database.child(getChatroomID(_id)).push().set(message).then((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Color? _getBubbleColor(int index) {
    return index % 2 == 0 ? Colors.grey[300] : Colors.blue[300];
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isCurrentUser, int index) {
    TextAlign textAlign = isCurrentUser ? TextAlign.left : TextAlign.right;
    Color bubbleColor = isCurrentUser ? Colors.grey[300]! : Colors.blue[300]!;

    return Align(
      alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _getBubbleColor(index),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(message['senderPhotoUrl'] ?? ''),
                ),
                SizedBox(width: 8.0),
                Text(
                  message['sender'] ?? 'Unknown User',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            if (message.containsKey('text'))
              Text(
                message['text'] ?? '',
                textAlign: textAlign,
                style: TextStyle(color: Colors.black),
              ),
            if (message.containsKey('image'))
              GestureDetector(
                onTap: () {
                  _showImageDialog(message['image']);
                },
                child: Image.network(
                  message['image'],
                  width: 200,
                  height: 200,
                ),
              ),
            SizedBox(height: 8.0),
            Text(
              '- ${_formatTimestamp(message['timestamp'] as int)}',
              style: TextStyle(fontSize: 12.0, color: Colors.black26),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered,
              ),
            ),
          ),
        );
      },
    );
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
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                var message = _messages[index];
                bool isCurrentUser = message['sender'] == _currentUser.displayName;

                return _buildMessageBubble(message, isCurrentUser, index);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.emoji_emotions),
                  onPressed: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                    });
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _sendImage,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          _showEmojiPicker
              ? EmojiPicker(
            onEmojiSelected: (category, emoji) {
              _textEditingController.text += emoji.emoji;
            },
          )
              : SizedBox(),
        ],
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat('MMM d, yyyy').format(dateTime);  // Format the date
    String formattedTime = DateFormat('h:mm a').format(dateTime);  // Format the time
    return '$formattedDate at $formattedTime';  // Combine date and time
  }
}

String getChatroomID(String id) {
  return 'chat$id';
}
