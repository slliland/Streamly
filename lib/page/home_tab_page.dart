import 'package:flutter/material.dart';
import 'package:flutter_nested/flutter_nested.dart';
import 'package:streamly/model/home_mo.dart';
import 'package:streamly/util/color.dart';
import 'package:streamly/widget/hi_banner.dart';

import '../http/core/hi_error.dart';
import '../http/dao/home_dao.dart';
import '../model/video_model.dart';
import '../util/toast.dart';
import '../widget/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage>
    with AutomaticKeepAliveClientMixin {
  List<VideoModel> videoList = [];
  int pageIndex = 1;
  bool _loading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print('dis:$dis');
      //当距离底部不足300时加载更多
      if (dis < 300 && !_loading) {
        print('------_loadData---');
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _loadData,
      color: primaryColor,
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: HiNestedScrollView(
              controller: _scrollController,
              itemCount: videoList.length,
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              headers: [
                if (widget.bannerList != null)
                  Padding(padding: EdgeInsets.only(bottom: 8), child: _banner())
              ],
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.82),
              itemBuilder: (BuildContext context, int index) {
                return VideoCard(videoMo: videoList[index]);
              })),
    );
  }

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: HiBanner(widget.bannerList!));
  }

  Future<void> _loadData({loadMore = false}) async {
    _loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    print('loading:currentIndex:$currentIndex');
    try {
      HomeMo result = await HomeDao.get(widget.categoryName,
          pageIndex: currentIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          if (result.videoList!.isNotEmpty) {
            //合成一个新数组
            videoList = [...videoList, ...?result.videoList];
            pageIndex++;
          }
        } else {
          videoList = result.videoList!;
        }
      });
      Future.delayed(Duration(milliseconds: 1000), () {
        _loading = false;
      });
    } on NeedAuth catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      _loading = false;
      print(e);
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
