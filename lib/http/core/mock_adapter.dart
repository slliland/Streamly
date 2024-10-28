import 'package:streamly/http/core/hi_net_adapter.dart';
import 'package:streamly/http/request/basic_request.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) {
    return Future.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse<T>(
        data: {"code": 0, "message": "success"} as T,
        request: request,
        statusCode: 200,
        statusMessage: "OK",
      );
    });
  }
}
