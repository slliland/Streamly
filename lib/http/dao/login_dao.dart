import 'package:streamly/db/hi_cache.dart';
import 'package:streamly/http/request/basic_request.dart';
import 'package:streamly/http/request/login_request.dart';
import 'package:streamly/http/request/registration_request.dart';

import '../core/hi_net.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass";
  static login(String userName, String password) {
    return _send(userName, password);
  }

  static registration(
      String userName, String password, String imoocId, String orderId) {
    // Use named parameters for imoocId and orderId in _send
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password,
      {String? imoocId, String? orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
    } else {
      request = LoginRequest();
    }

    // Only add non-null values
    request.add('userName', userName).add("password", password);

    if (imoocId != null) {
      request.add("imoocId", imoocId);
    }
    if (orderId != null) {
      request.add("orderId", orderId);
    }

    var result = await HiNet.getInstance().fire(request);
    print(result);
    if (result['code'] == 0 && result['data'] != null) {
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS) ?? '';
  }
}
