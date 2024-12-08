import '../core/hi_net.dart';
import '../request/basic_request.dart';
import '../request/cancel_like_request.dart';
import '../request/like_request.dart';

class LikeDao {
  //https://api.devio.org/uapi/fa/like/BV1A5411L71X
  static like(String vid, bool like) async {
    BaseRequest request = like ? LikeRequest() : CancelLikeRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return result;
  }
}
