import 'package:chewie/chewie.dart' hide MaterialControls;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:streamly/util/color.dart';
import 'package:streamly/util/view_util.dart';
import 'package:video_player/video_player.dart';

import 'hi_video_controls.dart';

class VideoView extends StatefulWidget {
  final String url;
  final String cover;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final Widget? overlayUI;

  const VideoView(this.url,
      {Key? key,
      required this.cover,
      this.autoPlay = false,
      this.looping = false,
      this.aspectRatio = 16 / 9,
      this.overlayUI})
      : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController; //video_player播放器Controller
  late ChewieController _chewieController; //chewie播放器Controller
  //封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover),
      );

  //进度条颜色配置
  get _progressColors => ChewieProgressColors(
      playedColor: primaryColor,
      handleColor: primaryColor,
      backgroundColor: Colors.grey,
      bufferedColor: primaryColor.shade50);

  @override
  void initState() {
    super.initState();
    //初始化播放器设置
    _videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        //fix iOS无法正常退出全屏播放问题
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        aspectRatio: widget.aspectRatio,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        placeholder: _placeholder,
        allowMuting: false,
        allowPlaybackSpeedChanging: false,
        customControls: MaterialControls(
          showLoadingOnInitialize: false,
          showBigPlayIcon: false,
          bottomGradient: blackLinearGradient(),
          overlayUI: widget.overlayUI,
        ),
        materialProgressColors: _progressColors);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;
    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
