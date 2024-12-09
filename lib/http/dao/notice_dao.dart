import '../../model/notice_mo.dart';
import '../core/hi_net.dart';
import '../request/notice_request.dart';

class NoticeDao {
  //https://api.devio.org/uapi/fa/notice?pageIndex=1&pageSize=10
  static noticeList({int pageIndex = 1, int pageSize = 10}) async {
    NoticeRequest request = NoticeRequest();
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return NoticeMo.fromJson(result['data']);
  }
}
