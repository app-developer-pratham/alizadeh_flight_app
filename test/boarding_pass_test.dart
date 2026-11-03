import 'package:alizadeh_flight_app/models/flight.dart';
import 'package:alizadeh_flight_app/screens/boarding_pass_screen.dart';
import 'package:alizadeh_flight_app/widgets/boarding_pass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BoardingPassScreen renders single ticket cleanly without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final flight = Flight.sampleFlights.first;

    await tester.pumpWidget(
      MaterialApp(
        home: BoardingPassScreen(
          flight: flight,
          selectedSeats: const ['04A'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Boarding Pass'), findsOneWidget);
    expect(find.text('American Airlines'), findsOneWidget);
    expect(find.text('JFK'), findsOneWidget);
    expect(find.text('ZHR'), findsOneWidget);
    expect(find.text('04A'), findsOneWidget);
    expect(find.text('Book Flight • \$560'), findsOneWidget);
  });

  testWidgets(
      'BoardingPassScreen handles 10 tickets booking edge case without any overflow',
      (WidgetTester tester) async {
    // Test on a smaller physical size to strictly ensure no RenderFlex overflow
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final flight = Flight.sampleFlights.first;
    final tenSeats = [
      '01A',
      '01B',
      '01C',
      '02A',
      '02B',
      '02C',
      '03A',
      '03B',
      '04A',
      '04B'
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: BoardingPassScreen(
          flight: flight,
          selectedSeats: tenSeats,
          customPrice: 5600,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify 10 tickets header and pass indicator
    expect(find.text('TICKETS (10 BOOKED)'), findsOneWidget);
    expect(find.text('Pass 1 of 10'), findsOneWidget);

    // Verify button shows formatted 10 tickets total price ($5,600)
    expect(find.text('Book 10 Tickets • \$5,600'), findsOneWidget);

    // Verify visible seat chips in ticket switcher tab bar
    expect(find.text('#1 (${tenSeats[0]})'), findsOneWidget);
    expect(find.text('#2 (${tenSeats[1]})'), findsOneWidget);

    // Verify first pass details
    expect(find.text('01A'), findsWidgets);

    // Tap on second ticket tab (#2 01B)
    await tester.tap(find.text('#2 (01B)'));
    await tester.pumpAndSettle();

    // Verify state updated
    expect(find.text('Pass 2 of 10'), findsOneWidget);

    // Scroll and tap Book 10 Tickets button to confirm booking
    final bookButtonFinder = find.text('Book 10 Tickets • \$5,600');
    await tester.ensureVisible(bookButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(bookButtonFinder);
    await tester.pumpAndSettle();

    // Verify confirmed state
    expect(find.text('Save 10 Passes to Apple Wallet'), findsOneWidget);
  });

  testWidgets('BoardingPassCard standalone edge case test',
      (WidgetTester tester) async {
    final flight = Flight.sampleFlights.first;
    final tenSeats = [
      '01A',
      '01B',
      '01C',
      '02A',
      '02B',
      '02C',
      '03A',
      '03B',
      '04A',
      '04B'
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: BoardingPassCard(
              flight: flight,
              seatNumber: '01A',
              passengerName:
                  'Dr. ExtremelyLongPassengerNameWithManyTitles Alizadeh Jr.',
              allSeats: tenSeats,
              ticketIndex: 0,
              totalTickets: 10,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pass 1/10'), findsOneWidget);
    expect(find.text('BOOKED SEATS (10)'), findsOneWidget);
  });
}
