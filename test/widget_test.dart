import 'package:alizadeh_flight_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FlightBookingApp initial onboarding test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FlightBookingApp(initialRoute: '/onboarding'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('AERO'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Discover Your\nDream Flight'), findsOneWidget);

    // Tapping Skip navigates to FlightBookingScreen
    await tester.tap(find.text('Skip'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('JFK'), findsWidgets);
    expect(find.text('ZHR'), findsWidgets);
    expect(find.text('Round trip'), findsOneWidget);
  });

  testWidgets('FlightBookingApp booking screen smoke test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FlightBookingApp(initialRoute: '/booking'));
    await tester.pumpAndSettle();

    expect(find.text('JFK'), findsWidgets);
    expect(find.text('ZHR'), findsWidgets);
    expect(find.text('Round trip'), findsOneWidget);
    expect(find.text('American Airlines'), findsWidgets);
  });
}
