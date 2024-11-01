import 'package:flutter/material.dart';
import 'package:streamly/model/video_model.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<VideoModel> onJumpToDetail;

  const HomePage({Key? key, required this.onJumpToDetail}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Streamly Home Page'),
            MaterialButton(
              color: Colors.blue,
              onPressed: () {
                // Navigate to detail page with a dummy VideoModel
                widget.onJumpToDetail(VideoModel(vid: 1));
              },
              child: Text(
                'Go to Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
