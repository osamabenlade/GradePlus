import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Aboutus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomExpansionTile(
              title: 'About GradePlus',
              description: Text(
                  'GradePlus is a dedicated app for the students of IIITA. Our aim is to provide a comprehensive platform where students can easily access lecture slides shared by professors, past year question papers, and other academic resources, all arranged systematically.'),
              leading: Image.asset(
                'assets/images/tmplogo.png',
                width: 50.0,
                height: 50.0,
              ),
              initiallyExpanded: true,
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Color(0xFFF1E6FF),
              animationDuration: Duration(microseconds: 1),
            ),
            SizedBox(height: 16.0),
            CustomExpansionTile(
              title: 'Features',
              description: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  children: [
                    TextSpan(
                      text:
                      '\n• Lecture slides, pyqs, notes, books, youtube links all at one place\n• Systematic arrangement of all academic resources\n• Real-time chat screen for each subject',
                    ),
                  ],
                ),
              ),
              leading: Icon(Icons.settings, color: Color(0xff6EE1FF), size: 36),
              initiallyExpanded: false,
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Color(0xFFF1E6FF),
              animationDuration: Duration(microseconds: 1),
            ),
            SizedBox(height: 16.0),
            CustomExpansionTile(
              title: 'Contributors',
              description: Column(
                children: [
                  ContributorTile(
                    imageUrl: 'assets/images/hima.jpg', // Replace with actual URL
                    name: 'Himanshu Raj',
                    githubUrl: 'https://github.com/himanshuhr8', // Replace with actual URL
                    linkedinUrl: 'https://www.linkedin.com/in/himanshu-raj-1053a4260/', // Replace with actual URL
                  ),
                  ContributorTile(
                    imageUrl: 'https://example.com/profile2.jpg', // Replace with actual URL
                    name: 'Ankit Kumar',
                    githubUrl: 'https://github.com/himanshuhr8', // Replace with actual URL
                    linkedinUrl: 'https://linkedin.com/in/developer2', // Replace with actual URL
                  ),
                  // Add more ContributorTile widgets as needed
                ],
              ),
              leading: Icon(Icons.people, color: Color(0xff6EE1FF), size: 35),
              initiallyExpanded: false,
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Color(0xFFF1E6FF),
              animationDuration: Duration(microseconds: 1),
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget description;
  final Widget leading;
  final bool initiallyExpanded;
  final Color backgroundColor;
  final Color collapsedBackgroundColor;
  final Duration animationDuration;

  CustomExpansionTile({
    required this.title,
    required this.description,
    required this.leading,
    this.initiallyExpanded = false,
    this.backgroundColor = Colors.white,
    this.collapsedBackgroundColor = Colors.white,
    this.animationDuration = const Duration(microseconds: 100),
  });

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.animationDuration,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              backgroundColor: widget.backgroundColor,
              collapsedBackgroundColor: widget.collapsedBackgroundColor,
              tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              childrenPadding: EdgeInsets.all(8.0),
              title: Row(
                children: [
                  widget.leading,
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.blue,
              ),
              initiallyExpanded: widget.initiallyExpanded,
              onExpansionChanged: (bool expanding) =>
                  setState(() => _isExpanded = expanding),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: widget.description,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContributorTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String githubUrl;
  final String linkedinUrl;

  ContributorTile({
    required this.imageUrl,
    required this.name,
    required this.githubUrl,
    required this.linkedinUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage:AssetImage(imageUrl),
      ),
      title: Text(name,style: TextStyle(fontSize: 16),),
      subtitle: Row(
        children: [
          IconButton(
            icon: Image.asset('assets/images/github_logo.png' ,height: 15,width: 15,),
            onPressed: () {
              // Handle GitHub icon press
              _launchURL(githubUrl);
            },
          ),
          IconButton(
            icon: Image.asset('assets/images/linkedin.png' ,height: 15,width: 15,),
            onPressed: () {
              // Handle LinkedIn icon press
              _launchURL(linkedinUrl);
            },
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
