import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import '../model/video_model.dart';
import '../navigator/hi_navigator.dart';
import '../provider/theme_provider.dart';
import '../util/format_util.dart';
import '../util/view_util.dart';

class VideoLargeCard extends StatefulWidget {
  final VideoModel videoModel;

  const VideoLargeCard({Key? key, required this.videoModel}) : super(key: key);

  @override
  _VideoLargeCardState createState() => _VideoLargeCardState();
}

class _VideoLargeCardState extends State<VideoLargeCard> {
  String translatedTitle = '';
  String translatedOwnerName = '';

  @override
  void initState() {
    super.initState();
    _translateContent();
  }

  Future<void> _translateContent() async {
    final translator = GoogleTranslator();

    // Translate the title
    final titleTranslation =
        await translator.translate(widget.videoModel.title, to: 'en');

    // Translate the owner's name
    final ownerTranslation =
        await translator.translate(widget.videoModel.owner.name, to: 'en');

    setState(() {
      translatedTitle = titleTranslation.text;
      translatedOwnerName = ownerTranslation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    // GestureDetector: more than single click
    return GestureDetector(
      onTap: () {
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.detail, args: {"videoMo": widget.videoModel});
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
        padding: EdgeInsets.only(bottom: 6),
        height: 106,
        decoration: BoxDecoration(border: borderLine(context)),
        child: Row(children: [
          _itemImage(context),
          _buildContent(themeProvider),
        ]),
      ),
    );
  }

  _itemImage(BuildContext context) {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(widget.videoModel.cover,
              width: height * (16 / 9), height: height),
          Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  durationTransform(widget.videoModel.duration),
                  style: TextStyle(fontSize: 10),
                ),
              ))
        ],
      ),
    );
  }

  _buildContent(ThemeProvider themeProvider) {
    var textColor = themeProvider.isDark() ? Colors.grey : Colors.black87;
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 5, left: 8, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                translatedTitle.isNotEmpty
                    ? translatedTitle
                    : widget.videoModel.title, // Fallback to original title
                style: TextStyle(fontSize: 12, color: textColor),
                maxLines: 2, // Limit lines to prevent overflow
                overflow: TextOverflow.ellipsis, // Show ellipsis for overflow
              ),
            ),
            _buildBottomContent(),
          ],
        ),
      ),
    );
  }

  _buildBottomContent() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Author
          _owner(),
          hiSpace(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ...smallIconText(
                      Icons.ondemand_video, widget.videoModel.view),
                  hiSpace(width: 5),
                  ...smallIconText(Icons.list_alt, widget.videoModel.reply),
                ],
              ),
              Icon(
                Icons.more_vert_sharp,
                color: Colors.grey,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _owner() {
    var owner = widget.videoModel.owner;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.grey)),
          child: Text(
            'UP',
            style: TextStyle(
                color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
        hiSpace(width: 8),
        Text(
          translatedOwnerName.isNotEmpty
              ? translatedOwnerName
              : owner.name, // Fallback to original name
          style: TextStyle(fontSize: 11, color: Colors.grey),
        )
      ],
    );
  }
}
