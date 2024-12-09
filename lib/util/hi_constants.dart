import '../http/dao/login_dao.dart';

class HiConstants {
  static String authTokenK = "auth-token";
  static String authTokenV = "ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa";
  static String courseFlagK = "course-flag";
  static String courseFlagV = "fa";

  static headers() {
    /// Set request header validation, note the Console log output: flutter: received:
    Map<String, dynamic> header = {
      HiConstants.authTokenK: HiConstants.authTokenV,
      HiConstants.courseFlagK: HiConstants.courseFlagV
    };
    header[LoginDao.BOARDING_PASS] = LoginDao.getBoardingPass();
    return header;
  }
}
