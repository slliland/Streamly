import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamly/model/home_mo.dart';

import '../model/video_model.dart';

class VideoCard extends StatelessWidget {
  final VideoMo videoMo;
  const VideoCard({Key? key, required this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(videoMo.url);
      },
      child: Image.network(videoMo.cover!),
    );
  }
}
