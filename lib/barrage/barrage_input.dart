import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

/// Barrage Input Interface
class BarrageInput extends StatelessWidget {
  final VoidCallback onTabClose;

  const BarrageInput({Key? key, required this.onTabClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    FocusNode focusNode = FocusNode(); // Add focus node

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request focus after widget is built
      focusNode.requestFocus();
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Blank area to close the input
          Expanded(
            child: GestureDetector(
              onTap: () {
                onTabClose();
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  hiSpace(width: 15),
                  _buildInput(editingController, context, focusNode),
                  _buildSendBtn(editingController, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildInput(TextEditingController editingController, BuildContext context,
      FocusNode focusNode) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          autofocus: true,
          focusNode: focusNode, // Attach the focus node
          controller: editingController,
          onSubmitted: (value) {
            _send(value, context);
          },
          cursorColor: primaryColor,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
            hintText: "Enter a friendly barrage...",
          ),
        ),
      ),
    );
  }

  void _send(String text, BuildContext context) {
    if (text.isNotEmpty) {
      onTabClose();
      Navigator.pop(context, text);
    }
  }

  _buildSendBtn(TextEditingController editingController, BuildContext context) {
    return InkWell(
      onTap: () {
        var text = editingController.text.trim();
        _send(text, context);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(Icons.send_rounded, color: Colors.grey),
      ),
    );
  }
}
