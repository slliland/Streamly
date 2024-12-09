import 'package:flutter/material.dart';
import 'package:streamly/util/color.dart';

class BarrageSwitch extends StatefulWidget {
  /// Whether the barrage switch is initially expanded
  final bool initSwitch;

  /// Whether the input field is currently showing
  final bool inoutShowing;

  /// Callback for toggling the input field
  final VoidCallback onShowInput;

  /// Callback for toggling the expanded/collapsed state of the barrage switch
  final ValueChanged<bool> onBarrageSwitch;

  const BarrageSwitch(
      {Key? key,
      this.initSwitch = true,
      required this.onShowInput,
      required this.onBarrageSwitch,
      this.inoutShowing = false})
      : super(key: key);

  @override
  _BarrageSwitchState createState() => _BarrageSwitchState();
}

class _BarrageSwitchState extends State<BarrageSwitch> {
  late bool _barrageSwitch;

  @override
  void initState() {
    super.initState();
    _barrageSwitch = widget.initSwitch;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [_buildText(), _buildIcon()],
      ),
    );
  }

  _buildText() {
    var text = widget.inoutShowing ? 'Typing...' : 'Send Barrage';
    return _barrageSwitch
        ? InkWell(
            onTap: () {
              widget.onShowInput();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(text,
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          )
        : Container();
  }

  _buildIcon() {
    return InkWell(
      onTap: () {
        setState(() {
          _barrageSwitch = !_barrageSwitch;
        });
        widget.onBarrageSwitch(_barrageSwitch);
      },
      child: Icon(
        Icons.live_tv_rounded,
        color: _barrageSwitch ? primaryColor : Colors.grey,
      ),
    );
  }
}
