import 'package:hi_net/request/hi_base_request.dart';
import 'package:streamly/http/request/basic_request.dart';

class NoticeRequest extends BaseRequest {
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
    return 'uapi/notice';
  }
}
