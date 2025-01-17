import 'package:dio/dio.dart';

import '../request/hi_base_request.dart';
import 'hi_error.dart';
import 'hi_net_adapter.dart';

// Dio Adapter
class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    Response<dynamic>? response;
    Options options = Options(headers: request.header);
    var error;

    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioException catch (e) {
      error = e;
      response = e.response;
    }

    if (error != null) {
      throw HiNetError(
        response?.statusCode ?? -1,
        error.toString(),
        data: response != null ? buildRes(response, request) : null,
      );
    }

    if (response == null) {
      throw HiNetError(-1, "No response received", data: null);
    }

    return buildRes(response, request) as HiNetResponse<T>;
  }

  // Construct HiNetResponse
  HiNetResponse buildRes(Response<dynamic> response, HiBaseRequest request) {
    return HiNetResponse(
      data: response.data,
      request: request,
      statusCode: response.statusCode ?? -1,
      statusMessage: response.statusMessage ?? '',
      extra: response,
    );
  }
}
