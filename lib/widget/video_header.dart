import 'package:flutter/material.dart';
import 'package:hi_base/format_util.dart';
import 'package:hi_base/color.dart';
import 'package:translator/translator.dart';
import '../model/video_model.dart';

/// Detail page, author widget
class VideoHeader extends StatefulWidget {
  final Owner owner;

  const VideoHeader({Key? key, required this.owner}) : super(key: key);

  @override
  _VideoHeaderState createState() => _VideoHeaderState();
}

class _VideoHeaderState extends State<VideoHeader> {
  String translatedName = '';

  @override
  void initState() {
    super.initState();
    _translateName();
  }

  Future<void> _translateName() async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(widget.owner.name!, to: 'en');
    setState(() {
      translatedName = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Circular avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.owner.face!,
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    Text(
                      translatedName.isNotEmpty
                          ? translatedName
                          : widget.owner.name!,
                      style: TextStyle(
                          fontSize: 13,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${countFormat(widget.owner.fans!)} followers',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    )
                  ],
                ),
              )
            ],
          ),
          ElevatedButton(
            onPressed: () {
              print('---Follow---');
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: primaryColor, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded edges
              ),
              minimumSize: Size(50, 24), // Minimum size for height and width
              padding: EdgeInsets.symmetric(
                  horizontal: 16), // Padding for the button content
              elevation: 4, // Add some shadow for depth
            ),
            child: Text(
              '+ Follow',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
