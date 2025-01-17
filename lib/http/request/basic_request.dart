import 'package:hi_net/request/hi_base_request.dart';

import '../../util/hi_constants.dart';
import '../dao/login_dao.dart';

abstract class BaseRequest extends HiBaseRequest {
  @override
  String url() {
    if (needLogin()) {
      // Need Login with Token
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    return super.url();
  }

  Map<String, dynamic> header = {
    HiConstants.authTokenK: HiConstants.authTokenV,
    HiConstants.courseFlagK: HiConstants.courseFlagV
  };
}
