import 'package:hi_net/request/hi_base_request.dart';

import 'basic_request.dart';
import 'like_request.dart';

class CancelLikeRequest extends LikeRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}
