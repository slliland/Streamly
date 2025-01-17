import 'package:hi_net/hi_net.dart';

import '../../model/video_detail_mo.dart';
import '../request/video_detail_request.dart';

class VideoDetailDao {
  //https://api.devio.org/uapi/fa/detail/BV19C4y1s7Ka
  static get(String vid) async {
    VideoDetailRequest request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return VideoDetailMo.fromJson(result['data']);
  }
}
