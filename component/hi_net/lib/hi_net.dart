import 'package:hi_net/request/hi_base_request.dart';

import 'core/dio_adapter.dart';
import 'core/hi_error.dart';
import 'core/hi_interceptor.dart';
import 'core/hi_net_adapter.dart';

/// Network Manager Class
/// This class provides an abstraction layer for managing network requests and error handling.
class HiNet {
  /// Private constructor to implement Singleton pattern.
  HiNet._();

  /// Interceptor for handling errors globally.
  HiErrorInterceptor? _hiErrorInterceptor;

  /// Singleton instance of HiNet.
  static HiNet? _instance;

  /// Returns the Singleton instance of HiNet.
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  /// Executes a network request and handles the response or errors.
  /// [request]: The network request to execute.
  Future fire(HiBaseRequest request) async {
    HiNetResponse? response;
    var error;

    try {
      // Sends the network request and awaits the response.
      response = await send(request);
    } on HiNetError catch (e) {
      // Handles specific HiNet errors.
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      // Handles any other unexpected exceptions.
      error = e;
      printLog(e);
    }

    if (response == null) {
      // Logs the error if no response is received.
      printLog(error);
    }

    var result = response?.data;
    printLog(result);

    var status = response?.statusCode;
    var hiError;

    switch (status) {
      case 200:
        // Returns the result if the status code is 200 (success).
        return result;
      case 401:
        // Throws a NeedLogin error if status code is 401.
        hiError = NeedLogin();
        break;
      case 403:
        // Throws a NeedAuth error with additional data if status code is 403.
        hiError = NeedAuth(result.toString(), data: result);
        break;
      default:
        // For other status codes, throws a HiNetError with the existing error or new error details.
        hiError =
            error ?? HiNetError(status ?? -1, result.toString(), data: result);
        break;
    }

    // Passes the error to the interceptor for additional handling.
    if (_hiErrorInterceptor != null) {
      _hiErrorInterceptor!(hiError);
    }

    // Throws the processed error.
    throw hiError;
  }

  /// Sends a network request using the configured adapter (e.g., Dio).
  /// [request]: The network request to execute.
  /// Returns a [HiNetResponse] containing the response data.
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    /// Uses Dio as the HTTP adapter to send the request.
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  /// Sets a global error interceptor for handling errors.
  /// [interceptor]: The error interceptor to set.
  void setErrorInterceptor(HiErrorInterceptor interceptor) {
    this._hiErrorInterceptor = interceptor;
  }

  /// Logs network-related information or errors.
  /// [log]: The log message to output.
  void printLog(log) {
    print('hi_net:' + log.toString());
  }
}
