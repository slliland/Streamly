import 'package:hi_net/request/hi_base_request.dart';

import 'basic_request.dart';

class ProfileRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "uapi/fa/profile";
  }
}
