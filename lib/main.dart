import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/flight.dart';
import 'screens/boarding_pass_screen.dart';
import 'screens/flight_booking_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const FlightBookingApp());
}

class FlightBookingApp extends StatelessWidget {
  final String initialRoute;

  const FlightBookingApp({
    super.key,
    this.initialRoute = '/onboarding',
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Tickets Booking',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryRed,
          surface: AppColors.surfaceDark,
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const MainNavigationScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/booking': (context) => const FlightBookingScreen(),
        '/seat': (context) =>
            SeatSelectionScreen(flight: Flight.sampleFlights[0]),
        '/boarding-pass': (context) => const BoardingPassScreen(),
        '/boarding-pass-10': (context) => const BoardingPassScreen(
              selectedSeats: [
                '01A',
                '01B',
                '01C',
                '02A',
                '02B',
                '02C',
                '03A',
                '03B',
                '04A',
                '04B',
              ],
            ),
      },
    );
  }
}
