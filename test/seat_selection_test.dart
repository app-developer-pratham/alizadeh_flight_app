import 'package:alizadeh_flight_app/models/flight.dart';
import 'package:alizadeh_flight_app/screens/seat_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SeatSelectionScreen renders flight card, legend, and initial seats',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final flight = Flight.sampleFlights.first;

    await tester.pumpWidget(
      MaterialApp(
        home: SeatSelectionScreen(flight: flight),
      ),
    );
    await tester.pumpAndSettle();

    // Check title
    expect(find.text('Choose your seats'), findsOneWidget);

    // Check flight card details
    expect(find.text('American Airlines'), findsOneWidget);
    expect(find.text('A 380'), findsOneWidget);
    expect(find.text('JFK'), findsOneWidget);
    expect(find.text('ZHR'), findsOneWidget);

    // Check legend items
    expect(find.text('Unavailable'), findsOneWidget);
    expect(find.text('Available'), findsOneWidget);
    expect(find.text('Selected'), findsOneWidget);

    // Check initial selected summary (1E, 1F => 2 Adults, $1,120)
    expect(find.text('2 Adults'), findsOneWidget);
    expect(find.text('1E,1F'), findsOneWidget);
    expect(find.text('\$1,120'), findsOneWidget);

    // Check action button
    expect(find.text('Go to payment'), findsOneWidget);
  });

  testWidgets('Selecting an available seat updates summary and total payment',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final flight = Flight.sampleFlights.first;

    await tester.pumpWidget(
      MaterialApp(
        home: SeatSelectionScreen(flight: flight),
      ),
    );
    await tester.pumpAndSettle();

    // Tap on available seat 1A (first seat widget)
    final seat1AFinder = find.byWidgetPredicate(
      (widget) => widget.runtimeType.toString() == 'SeatWidget',
    );
    expect(seat1AFinder, findsWidgets);

    // Tap seat 1A (index 0)
    await tester.tap(seat1AFinder.first);
    await tester.pumpAndSettle();

    // Now 3 seats should be selected (1A, 1E, 1F) => 3 Adults, $1,680
    expect(find.text('3 Adults'), findsOneWidget);
    expect(find.text('1A,1E,1F'), findsOneWidget);
    expect(find.text('\$1,680'), findsOneWidget);
  });
}
