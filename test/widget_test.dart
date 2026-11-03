import 'package:flutter_test/flutter_test.dart';
import 'package:alizadeh_flight_app/main.dart';

void main() {
  testWidgets('FlightBookingApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlightBookingApp());
    expect(find.text('JFK'), findsWidgets);
    expect(find.text('ZHR'), findsWidgets);
    expect(find.text('Round trip'), findsOneWidget);
  });
}
