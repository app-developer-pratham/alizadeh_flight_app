import 'package:alizadeh_flight_app/models/flight.dart';
import 'package:alizadeh_flight_app/screens/boarding_pass_screen.dart';
import 'package:alizadeh_flight_app/screens/flight_booking_screen.dart';
import 'package:alizadeh_flight_app/screens/home_screen.dart';
import 'package:alizadeh_flight_app/screens/onboarding_screen.dart';
import 'package:alizadeh_flight_app/screens/seat_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('OnboardingScreen entrance animation runs and reveals content',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    // Initial frame
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('AERO'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    // Advance intro animation to completion
    await tester.pump(const Duration(milliseconds: 1200));

    expect(find.text('Discover Your\nDream Flight'), findsOneWidget);
    expect(find.text('SEAMLESS DISCOVERY'), findsOneWidget);
    expect(find.text('JFK ➔ ZHR'), findsOneWidget);
    expect(find.text('7h 35m • Direct'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    // Tap continue to advance to page 2
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Choose Your\nPreferred Seat'), findsOneWidget);
    expect(find.text('A 380 Cabin'), findsOneWidget);
  });

  testWidgets('Hero tags exist consistently across Home, Booking, Seat, and Boarding screens',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. HomeScreen has origin and destination Hero widgets
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    final homeOriginHero = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == 'route_from_JFK',
    );
    final homeDestHero = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == 'route_to_ZHR',
    );
    expect(homeOriginHero, findsOneWidget);
    expect(homeDestHero, findsOneWidget);

    // 2. FlightBookingScreen has matching origin and destination Hero widgets
    await tester.pumpWidget(
      const MaterialApp(
        home: FlightBookingScreen(
          fromCode: 'JFK',
          fromCity: 'New york',
          toCode: 'ZHR',
          toCity: 'Zurich',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final bookingOriginHero = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == 'route_from_JFK',
    );
    final bookingDestHero = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == 'route_to_ZHR',
    );
    expect(bookingOriginHero, findsOneWidget);
    expect(bookingDestHero, findsOneWidget);

    // Verify first flight ticket has flight Hero tag
    final sampleFlight = Flight.sampleFlights[0];
    final ticketHero = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == 'flight_ticket_${sampleFlight.id}',
    );
    expect(ticketHero, findsOneWidget);

    // 3. SeatSelectionScreen has matching ticket Hero tag
    await tester.pumpWidget(
      MaterialApp(
        home: SeatSelectionScreen(flight: sampleFlight),
      ),
    );
    await tester.pumpAndSettle();

    final seatTicketHero = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == 'flight_ticket_${sampleFlight.id}',
    );
    expect(seatTicketHero, findsOneWidget);

    // 4. BoardingPassScreen has boarding pass Hero tag
    await tester.pumpWidget(
      MaterialApp(
        home: BoardingPassScreen(flight: sampleFlight),
      ),
    );
    await tester.pumpAndSettle();

    final boardingPassHero = find.byWidgetPredicate(
      (widget) => widget is Hero && widget.tag == 'boarding_pass_${sampleFlight.id}',
    );
    expect(boardingPassHero, findsOneWidget);
  });

  testWidgets('FlightBookingScreen date and filter chips trigger live scanning state',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: FlightBookingScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap day 22
    final day22Finder = find.text('22');
    expect(day22Finder, findsOneWidget);
    await tester.tap(day22Finder);

    // Intermediate frame: live scanning banner appears
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('Searching live airline inventory'), findsOneWidget);

    // Settle search
    await tester.pumpAndSettle();
    expect(find.text('American Airlines'), findsWidgets);
  });

  testWidgets('BoardingPassScreen Apple Wallet save interaction works cleanly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: BoardingPassScreen(
          isBookingConfirmed: true,
          selectedSeats: ['04A'],
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Save to Apple Wallet button is present
    final walletBtn = find.text('Save to Apple Wallet');
    expect(walletBtn, findsOneWidget);

    await tester.tap(walletBtn);
    await tester.pumpAndSettle();

    // Button updates to confirmed indicator
    expect(find.textContaining('Apple Wallet'), findsWidgets);
  });
}
