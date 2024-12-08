import 'basic_request.dart';

class LikeRequest extends BaseRequest {
  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/like";
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }
}
