// General Net Return Format
import 'dart:convert';

import '../request/hi_base_request.dart';

abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request);
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
  HiBaseRequest request;
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
