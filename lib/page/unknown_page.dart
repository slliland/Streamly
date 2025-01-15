import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnKnownPage extends StatefulWidget {
  @override
  _UnKnownPageState createState() => _UnKnownPageState();
}

class _UnKnownPageState extends State<UnKnownPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('404'),
      ),
    );
  }
}
