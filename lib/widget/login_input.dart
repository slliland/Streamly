import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';

class LoginInput extends StatefulWidget {
  final String? title;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? initialValue; // New initialValue parameter

  const LoginInput(
    this.title,
    this.hint, {
    Key? key,
    this.onChanged,
    this.focusChanged,
    this.lineStretch = false,
    this.obscureText = false,
    this.keyboardType,
    this.initialValue, // Add initialValue to constructor
  }) : super(key: key);

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();
  late TextEditingController _controller; // Add TextEditingController

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.initialValue); // Initialize controller
    _focusNode.addListener(() {
      widget.focusChanged?.call(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                widget.title ?? '',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(child: _input())
          ],
        ),
        if (widget.lineStretch) Divider(height: 1, color: Colors.grey[300]),
        Padding(
            padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
            child: const Divider(
              height: 1,
              thickness: 0.5,
            ))
      ],
    );
  }

  Widget _input() {
    return TextField(
      controller: _controller, // Use controller for initialValue
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      autofocus: !widget.obscureText,
      cursorColor: primaryColor,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        border: InputBorder.none,
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
      ),
    );
  }
}
