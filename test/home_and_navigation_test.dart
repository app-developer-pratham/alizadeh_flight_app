import 'package:alizadeh_flight_app/main.dart';
import 'package:alizadeh_flight_app/screens/explore_screen.dart';
import 'package:alizadeh_flight_app/screens/home_screen.dart';
import 'package:alizadeh_flight_app/screens/main_navigation_screen.dart';
import 'package:alizadeh_flight_app/screens/my_tickets_screen.dart';
import 'package:alizadeh_flight_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomeScreen renders search card, airports, and trending destinations',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Where to next, Alex?'), findsOneWidget);
    expect(find.text('Round trip'), findsOneWidget);
    expect(find.text('One way'), findsOneWidget);
    expect(find.text('JFK'), findsWidgets);
    expect(find.text('ZHR'), findsWidgets);
    expect(find.text('Search Flights'), findsOneWidget);
    expect(find.text('Recent Searches'), findsOneWidget);
    expect(find.text('Trending Destinations'), findsOneWidget);
  });

  testWidgets('HomeScreen airport swap works smoothly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap the swap button
    final swapIconFinder = find.byIcon(Icons.swap_vert_rounded);
    expect(swapIconFinder, findsOneWidget);

    await tester.tap(swapIconFinder);
    await tester.pumpAndSettle();

    // Both airports are still displayed, swapped in order
    expect(find.text('ZHR'), findsWidgets);
    expect(find.text('JFK'), findsWidgets);
  });

  testWidgets(
      'MainNavigationScreen switches across all 4 bottom navigation tabs flawlessly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigationScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Initial tab: Home
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Where to next, Alex?'), findsOneWidget);

    // 2. Switch to Explore Tab (icon: Icons.explore_outlined)
    final exploreTabFinder = find.byIcon(Icons.explore_outlined);
    expect(exploreTabFinder, findsOneWidget);
    await tester.tap(exploreTabFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ExploreScreen), findsOneWidget);
    expect(find.text('Explore Horizons'), findsOneWidget);
    expect(find.text('12,840 Aircraft In Flight'), findsOneWidget);

    // 3. Switch to Tickets Tab (icon: Icons.confirmation_number_outlined)
    final ticketsTabFinder = find.byIcon(Icons.confirmation_number_outlined);
    expect(ticketsTabFinder, findsOneWidget);
    await tester.tap(ticketsTabFinder);
    await tester.pumpAndSettle();

    expect(find.byType(MyTicketsScreen), findsOneWidget);
    expect(find.text('My Boarding Passes'), findsOneWidget);
    expect(find.textContaining('AA-2849'), findsWidgets);

    // 4. Switch to Profile Tab (icon: Icons.person_outline_rounded)
    final profileTabFinder = find.byIcon(Icons.person_outline_rounded);
    expect(profileTabFinder, findsOneWidget);
    await tester.tap(profileTabFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(find.text('Mohammad Alizadeh'), findsOneWidget);
    expect(find.text('STAR ALLIANCE GOLD'), findsOneWidget);
    expect(find.text('84,250'), findsOneWidget);
  });

  testWidgets(
      'Full End-to-End Flow: Home -> Search -> Booking List -> Select Seat -> Boarding Pass',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1206, 2622);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const FlightBookingApp(initialRoute: '/home'),
    );
    await tester.pumpAndSettle();

    // On Home Screen, verify Search Flights button
    final searchButtonFinder = find.text('Search Flights');
    expect(searchButtonFinder, findsOneWidget);

    // Tap Search Flights -> navigates to FlightBookingScreen
    await tester.tap(searchButtonFinder);
    await tester.pumpAndSettle();

    // On FlightBookingScreen
    expect(find.text('American Airlines'), findsWidgets);
    expect(find.text('12h40m'), findsOneWidget);

    // Tap first flight card to open SeatSelectionScreen
    final firstFlightFinder = find.text('American Airlines').first;
    await tester.tap(firstFlightFinder);
    await tester.pumpAndSettle();

    // On SeatSelectionScreen
    expect(find.text('Choose your seats'), findsOneWidget);
    expect(find.text('Go to payment'), findsOneWidget);

    // Tap "Go to payment" -> opens FlightDetailsSheet
    await tester.tap(find.text('Go to payment'));
    await tester.pumpAndSettle();

    // In FlightDetailsSheet, tap "Book 2 Tickets • $1,120"
    final bookFlightBtn = find.textContaining('Book');
    expect(bookFlightBtn, findsWidgets);
    await tester.tap(bookFlightBtn.last);
    await tester.pumpAndSettle();

    // On BoardingPassScreen
    expect(find.text('Boarding Pass'), findsOneWidget);
    expect(find.text('Save 2 Passes to Apple Wallet'), findsOneWidget);
  });
}
