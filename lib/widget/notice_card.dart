import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../model/home_mo.dart';
import '../util/format_util.dart';
import '../util/view_util.dart';
import 'hi_banner.dart';

class NoticeCard extends StatefulWidget {
  final BannerMo bannerMo;

  const NoticeCard({Key? key, required this.bannerMo}) : super(key: key);

  @override
  _NoticeCardState createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  String translatedTitle = '';
  String translatedSubtitle = '';
  bool isTranslating = true;

  @override
  void initState() {
    super.initState();
    _translateContent();
  }

  Future<void> _translateContent() async {
    final translator = GoogleTranslator();

    try {
      // Translate the title and subtitle
      var titleTranslation =
          await translator.translate(widget.bannerMo.title ?? '', to: 'en');
      var subtitleTranslation =
          await translator.translate(widget.bannerMo.subtitle ?? '', to: 'en');

      setState(() {
        translatedTitle = titleTranslation.text;
        translatedSubtitle = subtitleTranslation.text;
        isTranslating = false;
      });
    } catch (e) {
      // Fallback to the original values if translation fails
      setState(() {
        translatedTitle = widget.bannerMo.title ?? 'Untitled';
        translatedSubtitle =
            widget.bannerMo.subtitle ?? 'No subtitle available';
        isTranslating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isTranslating
        ? Center(child: CircularProgressIndicator())
        : InkWell(
            onTap: () {
              handleBannerClick(widget.bannerMo);
            },
            child: Container(
              decoration: BoxDecoration(border: borderLine(context)),
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildIcon(),
                  hiSpace(width: 10),
                  _buildContents(),
                ],
              ),
            ),
          );
  }

  _buildIcon() {
    var iconData = widget.bannerMo.type == 'video'
        ? Icons.ondemand_video_outlined
        : Icons.card_giftcard;
    return Icon(
      iconData,
      size: 30,
    );
  }

  _buildContents() {
    return Flexible(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(translatedTitle, style: TextStyle(fontSize: 16)),
            Text(dateMonthAndDay(widget.bannerMo.createTime!)),
          ],
        ),
        hiSpace(height: 5),
        Text(
          translatedSubtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ));
  }
}
