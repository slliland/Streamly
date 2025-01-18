import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';
import 'package:provider/provider.dart';
import 'package:streamly/model/video_model.dart';
import 'package:streamly/navigator/hi_navigator.dart';
import 'package:hi_base/format_util.dart';
import 'package:streamly/util/view_util.dart';
import 'package:translator/translator.dart';

import '../provider/theme_provider.dart';

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
  bool _isDisposed = false; // Track disposal state

  @override
  void initState() {
    super.initState();
    _translateContent();
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed
    super.dispose();
  }

  /// Translates the title and owner name of the video
  void _translateContent() async {
    // Initialize with original values
    translatedTitle = widget.videoMo.title;
    translatedOwnerName = widget.videoMo.owner?.name ?? '';

    // Translate title if not empty
    if (widget.videoMo.title.isNotEmpty) {
      try {
        final translated =
            await translator.translate(widget.videoMo.title, to: 'en');
        if (!_isDisposed && mounted) {
          // Ensure the widget is still mounted and not disposed
          setState(() {
            translatedTitle = translated.text;
          });
        }
      } catch (e) {
        // Handle translation errors if necessary
        print('Translation error for title: $e');
      }
    }

    // Translate owner name if available
    if (widget.videoMo.owner?.name != null) {
      try {
        final translated =
            await translator.translate(widget.videoMo.owner!.name!, to: 'en');
        if (!_isDisposed && mounted) {
          // Ensure the widget is still mounted and not disposed
          setState(() {
            translatedOwnerName = translated.text;
          });
        }
      } catch (e) {
        // Handle translation errors if necessary
        print('Translation error for owner name: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color textColor = themeProvider.isDark() ? Colors.white70 : Colors.black87;
    return InkWell(
      onTap: () {
        print(widget.videoMo.url);
        HiNavigator.getInstance()
            .onJumpTo(RouteStatus.detail, args: {"videoMo": widget.videoMo});
      },
      child: SizedBox(
        height: 170,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemImage(context),
                _infoText(textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the video thumbnail with overlays for metadata (views, likes, duration)
  Widget _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Video Cover Image with fit parameter
        cachedImage(
          widget.videoMo.cover!,
          width: size.width / 2 - 10,
          height: 160,
          fit: BoxFit.cover, // Now supported by cachedImage
        ),
        // Overlay for Views, Likes, and Duration
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.ondemand_video, widget.videoMo.view!),
                _iconText(Icons.favorite_border, widget.videoMo.favorite!),
                _iconText(null, widget.videoMo.duration!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a row for an icon and its corresponding text
  Widget _iconText(IconData? iconData, int count) {
    String displayText;
    if (iconData != null) {
      displayText = countFormat(count);
    } else {
      displayText = durationTransform(widget.videoMo.duration!);
    }

    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            displayText,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ],
    );
  }

  /// Builds the video title and owner information section
  Widget _infoText(Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Title
          Text(
            translatedTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: textColor),
          ),
          const SizedBox(height: 5),
          // Owner Information
          _owner(textColor),
        ],
      ),
    );
  }

  /// Builds the owner section with avatar and name
  Widget _owner(Color textColor) {
    return Row(
      children: [
        // Owner Avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: cachedImage(
            widget.videoMo.owner?.face ?? '',
            height: 24,
            width: 24,
            fit: BoxFit.cover, // Now supported by cachedImage
          ),
        ),
        const SizedBox(width: 8),
        // Owner Name with Expanded to handle overflow
        Expanded(
          child: Text(
            translatedOwnerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: textColor),
          ),
        ),
        // More Options Icon
        const Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        ),
      ],
    );
  }
}
