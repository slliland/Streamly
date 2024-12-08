import 'package:flutter/material.dart';
import 'package:streamly/util/color.dart';
import 'package:translator/translator.dart';

import '../model/video_model.dart';
import '../util/format_util.dart';

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
          MaterialButton(
            onPressed: () {
              print('---Follow---');
            },
            color: primaryColor,
            height: 24,
            minWidth: 50,
            child: Text(
              '+ Follow',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
