// This is a basic Flutter integration test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';

import 'package:streamly/main.dart' as app;
import 'package:streamly/navigator/hi_navigator.dart';

// void main() => run(_testMain);

void _testMain() {
  testWidgets('Test login jump', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    app.main();

    // Trigger a frame.
    await tester.pumpAndSettle();

    // Find login button by key
    var registrationBtn = find.byKey(Key('registration'));

    // Trigger button
    await tester.tap(registrationBtn);

    // Catch a frame
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));

    //Judge if navigated to the registration page
    expect(HiNavigator.getInstance().getCurrent()?.routeStatus,
        RouteStatus.registration);

    //Get back button and trigger it back to the previous page
    var backBtn = find.byType(BackButton);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 3));
    //Judge if back to the login page
    expect(
        HiNavigator.getInstance().getCurrent()?.routeStatus, RouteStatus.login);
  });
}
