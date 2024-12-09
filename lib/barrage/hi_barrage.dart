import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'barrage_item.dart';
import '../model/barrage_model.dart';
import 'barrage_view_util.dart';
import 'hi_socket.dart';
import 'ibarrage.dart';

enum BarrageStatus { play, pause }

/// Barrage (bullet screen) widget
class HiBarrage extends StatefulWidget {
  final int lineCount; // Number of barrage lines
  final String vid; // Video ID for barrage association
  final int speed; // Speed of barrage movement (lower is faster)
  final double top; // Top margin for the barrage
  final bool autoPlay; // Whether to auto-play barrage
  final Map<String, dynamic>
      headers; // Request headers for WebSocket connection

  const HiBarrage({
    Key? key,
    this.lineCount = 4,
    required this.vid,
    this.speed = 800,
    this.top = 0,
    this.autoPlay = false,
    required this.headers,
  }) : super(key: key);

  @override
  HiBarrageState createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  late HiSocket _hiSocket;
  late double _height; // Barrage display area height
  late double _width; // Barrage display area width
  List<BarrageItem> _barrageItemList = []; // List of barrage widgets
  List<BarrageModel> _barrageModelList = []; // List of barrage data models
  int _barrageIndex = 0; // Current barrage index
  Random _random = Random();
  BarrageStatus? _barrageStatus;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket(widget.headers);
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    _hiSocket.close();
    _timer?.cancel();
    _barrageItemList.clear(); // Clear all barrages on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width / 16 * 9; // Calculate height based on 16:9 aspect ratio
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          // Prevent the Stack from being empty
          Container()
        ]..addAll(_barrageItemList),
      ),
    );
  }

  /// Handle incoming messages, instant=true to send immediately
  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }
    // Play barrage after receiving new messages
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }
    // Auto-play barrage if enabled and not paused
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    print('action:play');
    if (_timer != null && (_timer?.isActive ?? false)) return;
    // Send a barrage at regular intervals
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        // Remove the sent barrage from the list
        var temp = _barrageModelList.removeAt(0);
        temp.type = _random.nextInt(5) + 1; // Assign random type (1 to 5)
        addBarrage(temp);
        print('start:${temp.content}');
      } else {
        print('All barrages are sent.');
        // Stop the timer after all barrages are sent
        _timer?.cancel();
      }
    });
  }

  /// Add a barrage to the display
  void addBarrage(BarrageModel model) {
    double perRowHeight = 30; // Height of each line
    var line = _barrageIndex % widget.lineCount;
    _barrageIndex++;
    var top = line * perRowHeight + widget.top;
    // Generate a unique ID for each barrage
    String id = '${_random.nextInt(10000)}:${model.content}';
    var item = BarrageItem(
      id: id,
      top: top,
      child: BarrageViewUtil.barrageView(model),
      onComplete: _onComplete,
    );
    _barrageItemList.add(item);
    setState(() {});
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    // Clear all displayed barrages
    _barrageItemList.clear();
    setState(() {});
    print('action:pause');
    _timer?.cancel();
  }

  @override
  void send(String? message) {
    if (message == null) return;
    _hiSocket.send(message);
    _handleMessage(
        [BarrageModel(content: message, vid: '-1', priority: 1, type: 1)]);
  }

  void _onComplete(id) {
    print('Done:$id');
    // Remove completed barrage from the widget list
    _barrageItemList.removeWhere((element) => element.id == id);
  }
}
