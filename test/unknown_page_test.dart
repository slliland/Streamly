import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamly/page/unknown_page.dart';

void main() {
  testWidgets('test for unknown page', (WidgetTester widgetTester) async {
    var app = MaterialApp(home: UnKnownPage());
    await widgetTester.pumpWidget(app);
    expect(find.text('404'), findsOneWidget);
  });
}
