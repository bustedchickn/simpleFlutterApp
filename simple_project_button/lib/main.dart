import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChallengeDescription extends StatelessWidget {
  final String text;
  final String? linkText;
  final String? url;
  final String? imageUrl;      // for online image
  final String? localImage;    // for local image (e.g. "assets/images/my_image.png")

  const ChallengeDescription({
    required this.text,
    this.linkText,
    this.url,
    this.imageUrl,
    this.localImage,
    Key? key,
  }) : super(key: key);

  void _launchURL(BuildContext context) async {
    if (url == null) return;
    final uri = Uri.parse(url!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch URL")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
        if (url != null && linkText != null)
          GestureDetector(
            onTap: () => _launchURL(context),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                linkText!,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        if (imageUrl != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.network(imageUrl!),
          ),
        if (localImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Image.asset(localImage!),
          ),
      ],
    );
  }
}

void main() {
  runApp(ChallengeApp());
}




class Challenge {
  final String title;
  final Widget description;
  
  bool isCompleted;

  Challenge({required this.title, required this.description, this.isCompleted = false });
}

class ChallengeApp extends StatefulWidget {
  @override
  _ChallengeAppState createState() => _ChallengeAppState();
}

class _ChallengeAppState extends State<ChallengeApp> {
  List<Challenge> challenges = [
    Challenge(title: "Go to the BYU-I letters", description:
      ChallengeDescription(
        text: 'Take a picture of yourself next to the big, blue BYU-I letters',
        linkText: "Learn more here",
        url: "https://www.youtube.com/watch?v=QREUmhrZ95c",
        localImage: "assets/IMG_3543.jpg",
        ), 
      ),
    Challenge(title: "Go to one of your professors offices", description: 
      ChallengeDescription(text: 'Find your proffessors'),
      ),
    Challenge(title: "Go to president's dinner", description: 
      ChallengeDescription(text: "Try going to president's dinner Thursday night!",
      localImage: 'assets/kingjoey.jpg',
      )
    ),
  ];

  void toggleCompletion(int index) {
    setState(() {
      challenges[index].isCompleted = !challenges[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge Tracker',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Challenge card!'),
        ),
        body: ListView.builder(
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return ExpansionTile(
              title: Text(challenge.title),
              trailing: AnimatedCheckIcon(isChecked: challenge.isCompleted),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: challenge.description
                ),
                TextButton(
                  onPressed: () => toggleCompletion(index),
                  child: Text(
                    challenge.isCompleted ? 'Mark Incomplete' : 'Mark Complete',
                  ),
                ),
              ],             
            );
          },
        ),
      ),
    );
  }
}

class AnimatedCheckIcon extends StatefulWidget {
  final bool isChecked;

  const AnimatedCheckIcon({required this.isChecked, Key? key}) : super(key: key);

  @override
  _AnimatedCheckIconState createState() => _AnimatedCheckIconState();
}

class _AnimatedCheckIconState extends State<AnimatedCheckIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedCheckIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: Icon(
          widget.isChecked ? Icons.check_box : Icons.check_box_outline_blank,
          key: ValueKey(widget.isChecked),
          color: widget.isChecked ? Colors.green : null,
        ),
      ),
    );
  }
}


