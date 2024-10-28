import 'package:flutter/cupertino.dart';
import 'package:streamly/http/core/dio_adapter.dart';
import 'package:streamly/http/core/hi_error.dart';
import 'package:streamly/http/core/hi_net_adapter.dart';
import 'package:streamly/http/core/mock_adapter.dart';
import 'package:streamly/http/request/basic_request.dart';

class HiNet {
  HiNet._();
  // Nullable to handle initialization safely
  static HiNet? _instance;

  // Factory Constructor for initialization
  factory HiNet() {
    _instance ??= HiNet._();
    return _instance!;
  }

  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  Future<dynamic> fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request: request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      error = e;
      printLog(e);
    }

    // Explicitly handle null response
    if (response == null) {
      printLog(error);
      throw error ?? Exception("Unknown error occurred");
    }

    var result =
        response.data ?? {}; // Provide an empty Map as fallback if null
    printLog(result);

    switch (response.statusCode) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(response.statusCode ?? -1, result.toString(),
            data: result);
    }
  }

  Future<HiNetResponse<T>> send<T>({required BaseRequest request}) async {
    printLog('url: ${request.url()}');
    // HiNetAdapter adapter = MockAdapter();
    HiNetAdapter adapter = DioAdapter();
    return await adapter.send(request);
  }

  void printLog(dynamic log) {
    print('hi_net: ${log.toString()}');
  }
}
