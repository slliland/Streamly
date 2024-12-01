import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamly/model/home_mo.dart';
import 'package:transparent_image/transparent_image.dart';

import '../model/video_model.dart';
import '../navigator/hi_navigator.dart';
import '../util/format_util.dart';
import '../util/view_util.dart';

/// VideoCard widget that displays a video thumbnail with metadata such as views, likes, and duration
class VideoCard extends StatelessWidget {
  /// The video metadata model
  final VideoModel videoMo;

  /// Constructor with required video model parameter
  const VideoCard({Key? key, required this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(

        /// Tap action to navigate to the video details page
        onTap: () {
          print(videoMo.url);
          HiNavigator.getInstance()
              .onJumpTo(RouteStatus.detail, args: {"videoMo": videoMo});
        },
        child: SizedBox(
          /// Defines the size of the VideoCard
          height: 170, // Adjust height of the card here
          child: Card(
            /// Removes the default margin of the Card widget
            margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
            child: ClipRRect(
              /// Adds rounded corners to the card
              borderRadius: BorderRadius.circular(5),
              child: Column(
                /// Ensures children are aligned to the start of the column
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _itemImage(context), // Video thumbnail section
                  _infoText(), // Video title and owner section
                ],
              ),
            ),
          ),
        ));
  }

  /// Builds the video thumbnail with overlays for views, likes, and duration
  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size; // Retrieves the device size
    return Stack(
      children: [
        /// Cached image for the video cover
        cachedImage(videoMo.cover!, width: size.width / 2 - 10, height: 160),
        Positioned(

            /// Overlay position for video metadata (views, likes, duration)
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 2, top: 2),
              decoration: const BoxDecoration(

                  /// Adds a gradient overlay for better contrast
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, videoMo.view!), // View count
                  _iconText(
                      Icons.favorite_border, videoMo.favorite!), // Likes count
                  _iconText(null, videoMo.duration!), // Video duration
                ],
              ),
            ))
      ],
    );
  }

  /// Builds a row for an icon and its corresponding text
  _iconText(IconData? iconData, int count) {
    String views = "";
    if (iconData != null) {
      views = countFormat(count); // Formats the count (e.g., 1.2K, 1.2M)
    } else {
      views = durationTransform(videoMo.duration!); // Formats video duration
    }
    return Row(
      children: [
        if (iconData != null)
          Icon(iconData, color: Colors.white, size: 12), // Icon
        Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(views,
                style: TextStyle(color: Colors.white, fontSize: 10))) // Text
      ],
    );
  }

  /// Builds the video title and owner information section
  _infoText() {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Video title
          Text(
            videoMo.title,
            maxLines: 2, // Limits title to 2 lines
            overflow: TextOverflow.ellipsis, // Adds ellipsis for overflow
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          _owner() // Owner info
        ],
      ),
    ));
  }

  /// Builds the owner section with avatar and name
  _owner() {
    var owner = videoMo.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            /// Owner's avatar
            ClipRRect(
                borderRadius: BorderRadius.circular(12), // Circular avatar
                child: cachedImage(owner!.face!, height: 24, width: 24)),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                owner.name!, // Owner's name
                style: TextStyle(fontSize: 11, color: Colors.black87),
              ),
            )
          ],
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
