// General Net Return Format
import 'package:streamly/http/request/basic_request.dart';
import 'dart:convert';

abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

class HiNetResponse<T> {
  HiNetResponse({
    required this.data,
    required this.request,
    required this.statusCode,
    required this.statusMessage,
    this.extra,
  });

  T data;
  BaseRequest request;
  int statusCode;
  String statusMessage;
  dynamic extra;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
