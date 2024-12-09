import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/home_mo.dart';
import '../model/video_model.dart';
import '../navigator/hi_navigator.dart';

class HiBanner extends StatelessWidget {
  final List<BannerMo> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry? padding;

  const HiBanner(this.bannerList,
      {Key? key, this.bannerHeight = 160, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('HiBanner received bannerList: $bannerList');
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        // print('Rendering banner at index: $index');
        return _image(bannerList[index]);
      },
      pagination: SwiperPagination(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(right: right, bottom: 10),
          builder: const DotSwiperPaginationBuilder(
              color: Colors.white60, size: 6, activeSize: 6)),
    );
  }

  _image(BannerMo bannerMo) {
    // print('BannerMo cover: ${bannerMo.cover}');
    return InkWell(
      onTap: () {
        // print('Banner title: ${bannerMo.title}');
        handleBannerClick(bannerMo);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          child: bannerMo.cover != null && bannerMo.cover!.startsWith('images/')
              ? Image.asset(
                  bannerMo.cover!,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  bannerMo.cover ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

void handleBannerClick(BannerMo bannerMo) {
  if (bannerMo.type == 'video') {
    HiNavigator.getInstance().onJumpTo(RouteStatus.detail,
        args: {"videoMo": VideoModel(vid: bannerMo.url!)});
  } else {
    HiNavigator.getInstance().openH5(bannerMo.url!);
  }
}
