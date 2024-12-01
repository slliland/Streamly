import 'package:flutter/material.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:streamly/util/format_util.dart';
import 'package:streamly/util/view_util.dart';
import 'package:translator/translator.dart';

/// VideoCard widget that displays a video thumbnail with metadata such as views, likes, and duration
class VideoCard extends StatefulWidget {
  /// The video metadata model
  final VideoModel videoMo;

  /// Constructor with required video model parameter
  const VideoCard({Key? key, required this.videoMo}) : super(key: key);

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  String translatedTitle = '';
  String translatedOwnerName = '';
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _translateContent();
  }

  /// Translates the title and owner name of the video
  void _translateContent() async {
    translatedTitle = widget.videoMo.title; // Default to original title
    translatedOwnerName =
        widget.videoMo.owner?.name ?? ''; // Default owner name

    if (widget.videoMo.title.isNotEmpty) {
      final translated =
          await translator.translate(widget.videoMo.title, to: 'en');
      setState(() {
        translatedTitle = translated.text;
      });
    }

    if (widget.videoMo.owner?.name != null) {
      final translated =
          await translator.translate(widget.videoMo.owner!.name!, to: 'en');
      setState(() {
        translatedOwnerName = translated.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          print(widget.videoMo.url);
          HiNavigator.getInstance()
              .onJumpTo(RouteStatus.detail, args: {"videoMo": widget.videoMo});
        },
        child: SizedBox(
          height: 170,
          child: Card(
            margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _itemImage(context),
                  _infoText(),
                ],
              ),
            ),
          ),
        ));
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(widget.videoMo.cover!,
            width: size.width / 2 - 10, height: 160),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 2, top: 2),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, widget.videoMo.view!),
                  _iconText(Icons.favorite_border, widget.videoMo.favorite!),
                  _iconText(null, widget.videoMo.duration!),
                ],
              ),
            ))
      ],
    );
  }

  _iconText(IconData? iconData, int count) {
    String views = "";
    if (iconData != null) {
      views = countFormat(count);
    } else {
      views = durationTransform(widget.videoMo.duration!);
    }
    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(views,
                style: TextStyle(color: Colors.white, fontSize: 10)))
      ],
    );
  }

  _infoText() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translatedTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          _owner()
        ],
      ),
    ));
  }

  _owner() {
    var owner = VideoModel.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              /// Owner's avatar
              ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Circular avatar
                  child: cachedImage(owner!.face!, height: 24, width: 24)),
              SizedBox(width: 8), // Add spacing between avatar and text
              Expanded(
                child: Text(
                  owner.name!, // Owner's name
                  maxLines: 1, // Limit to a single line
                  overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                  style: TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.more_vert_sharp, // Options icon
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}
