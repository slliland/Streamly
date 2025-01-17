import 'package:hi_net/request/hi_base_request.dart';
import 'package:streamly/http/request/basic_request.dart';

class LoginRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return '/uapi/user/login';
  }
}
