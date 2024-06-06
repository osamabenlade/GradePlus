import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LinksContent extends StatelessWidget {
  final String subjectData;

  LinksContent(this.subjectData);
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Subjects')
            .doc(subjectData)
            .collection('links')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

              if (data == null || data.isEmpty) {
                return SizedBox();
              }

              String itemName = data['itemName'];
              String itemLink = data['link'];
              //print("llhh $itemLink");

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(itemName),
                    trailing: IconButton(
                      icon: Icon(Icons.open_in_new),
                      onPressed: () {
                        if (itemLink != null) {
                          _launchURL(itemLink);
                          // String? videoId = YoutubePlayer.convertUrlToId(itemLink);
                          // if (videoId != null) {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => YoutubePlayer(
                          //         controller: YoutubePlayerController(
                          //           initialVideoId: videoId,
                          //           flags: YoutubePlayerFlags(
                          //             autoPlay: true,
                          //             mute: false,
                          //           ),
                          //         ),
                          //         showVideoProgressIndicator: true,
                          //         progressIndicatorColor: Colors.blueAccent,
                          //         progressColors: ProgressBarColors(
                          //           playedColor: Colors.blue,
                          //           handleColor: Colors.blueAccent,
                          //         ),
                          //       ),
                          //     ),
                          //   );
                          // }
                          // else {
                          //   print('Invalid YouTube URL');
                          // }
                        }
                        else {
                          print('URL is null');
                        }
                      },

                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}




