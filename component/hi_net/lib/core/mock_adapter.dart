import '../request/hi_base_request.dart';
import 'hi_net_adapter.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) {
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
