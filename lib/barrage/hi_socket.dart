import 'package:flutter/cupertino.dart';
import 'package:streamly/http/dao/login_dao.dart';
import 'package:web_socket_channel/io.dart';

import '../model/barrage_model.dart';
import '../util/hi_constants.dart';

/// Responsible for WebSocket communication with the backend
class HiSocket implements ISocket {
  late final Map<String, dynamic> headers;
  static const _URL = 'wss://api.devio.org/uapi/fa/barrage/';
  IOWebSocketChannel? _channel;
  ValueChanged<List<BarrageModel>>? _callBack;

  /// Heartbeat interval in seconds. Adjust this based on the actual server timeout.
  /// Here, the Nginx server timeout is 60 seconds.
  int _intervalSeconds = 50;

  HiSocket(this.headers);

  @override
  void close() {
    if (_channel != null) {
      _channel?.sink.close();
    }
  }

  @override
  ISocket listen(callBack) {
    _callBack = callBack;
    return this;
  }

  @override
  ISocket open(String vid) {
    _channel = IOWebSocketChannel.connect(_URL + vid,
        headers: headers, pingInterval: Duration(seconds: _intervalSeconds));
    _channel?.stream.handleError((error) {
      print('Connection error occurred: $error');
    }).listen((message) {
      _handleMessage(message);
    });
    return this;
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }

  /// Handles server responses
  void _handleMessage(message) {
    print('Received: $message');
    var result = BarrageModel.fromJsonString(message);
    if (_callBack != null) {
      _callBack!(result);
    }
  }
}

abstract class ISocket {
  /// Establishes a connection with the server
  ISocket open(String vid);

  /// Sends a message
  ISocket send(String message);

  /// Closes the connection
  void close();

  /// Listens for messages
  ISocket listen(ValueChanged<List<BarrageModel>> callBack);
}
