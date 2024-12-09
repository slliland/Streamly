import 'package:flutter/cupertino.dart';

import '../core/hi_base_tab_state.dart';
import '../http/dao/ranking_dao.dart';
import '../model/ranking_mo.dart';
import '../model/video_model.dart';
import '../widget/video_large_card.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;

  const RankingTabPage({Key? key, required this.sort}) : super(key: key);

  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState
    extends HiBaseTabState<RankingMo, VideoModel, RankingTabPage> {
  @override
  get contentChild => Container(
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 0),
            itemCount: dataList.length,
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) =>
                VideoLargeCard(videoModel: dataList[index])),
      );

  @override
  Future<RankingMo> getData(int pageIndex) async {
    RankingMo result =
        await RankingDao.get(widget.sort, pageIndex: pageIndex, pageSize: 20);
    return result;
  }

  @override
  List<VideoModel> parseList(RankingMo result) {
    return result.list;
  }
}
