import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamly/util/view_util.dart';
import 'package:translator/translator.dart';
import '../model/video_model.dart';

class ExpandableContent extends StatefulWidget {
  final VideoModel mo;

  const ExpandableContent({Key? key, required this.mo}) : super(key: key);

  @override
  _ExpandableContentState createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  // Tween used for ease-in and bounce effect
  static final Animatable<double> _easeInOutTween =
      CurveTween(curve: Curves.easeInOutQuad);
  static final Animatable<double> _fadeTween =
      Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOut));

  bool _expand = false;

  // Controller to manage the animation
  late AnimationController _controller;

  // Generates the animation height values
  late Animation<double> _heightFactor;
  late Animation<double> _fadeAnimation;

  String translatedTitle = '';
  String translatedDesc = '';

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _heightFactor = _controller.drive(_easeInOutTween);
    _fadeAnimation = _controller.drive(_fadeTween);
    _translateContent();
  }

  Future<void> _translateContent() async {
    final translator = GoogleTranslator();
    final titleTranslation =
        await translator.translate(widget.mo.title, to: 'en');
    final descTranslation =
        await translator.translate(widget.mo.desc, to: 'en');
    setState(() {
      translatedTitle = titleTranslation.text;
      translatedDesc = descTranslation.text;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: [
          _buildTitle(),
          Padding(
            padding: EdgeInsets.only(bottom: 8),
          ),
          _buildInfo(),
          _buildDes()
        ],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use Expanded to allow Text to take maximum width for ellipsis
          Expanded(
              child: AnimatedCrossFade(
            duration: Duration(milliseconds: 300),
            firstChild: Text(
              translatedTitle.isNotEmpty
                  ? translatedTitle
                  : widget.mo.title, // Fallback to original title
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              translatedTitle.isNotEmpty
                  ? translatedTitle
                  : widget.mo.title, // Fallback to original title
              style: TextStyle(fontSize: 14),
            ),
            crossFadeState:
                _expand ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          )),
          Padding(padding: EdgeInsets.only(left: 15)),
          Icon(
            _expand
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            color: Colors.grey,
            size: 16,
          )
        ],
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        // Play animation forward
        _controller.forward();
      } else {
        // Reverse the animation
        _controller.reverse();
      }
    });
  }

  _buildInfo() {
    var style = TextStyle(fontSize: 12, color: Colors.grey);
    var dateStr = widget.mo.createTime.length > 10
        ? widget.mo.createTime.substring(5, 10)
        : widget.mo.createTime;
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.mo.view),
        Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconText(Icons.list_alt, widget.mo.reply),
        Text('    $dateStr', style: style)
      ],
    );
  }

  _buildDes() {
    var child = _expand
        ? FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              translatedDesc.isNotEmpty
                  ? translatedDesc
                  : widget.mo.desc, // Fallback to original description
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
        : null;

    // Build a generic widget for the animation
    return AnimatedBuilder(
      animation: _controller.view,
      child: child,
      builder: (BuildContext context, Widget? child) {
        return Align(
          heightFactor: _heightFactor.value,
          // Fix for expanding from the position above the layout
          alignment: Alignment.topCenter,
          child: Container(
            // Stretches to full width and aligns content
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(top: 8),
            child: child,
          ),
        );
      },
    );
  }
}
