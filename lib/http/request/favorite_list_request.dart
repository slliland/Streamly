import 'package:hi_net/request/hi_base_request.dart';

import 'basic_request.dart';

class FavoriteListRequest extends BaseRequest {
  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/favorites";
  }

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }
}
