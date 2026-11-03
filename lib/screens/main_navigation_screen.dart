import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'my_tickets_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Current Active Tab Screen with Smooth Fade Transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: _buildCurrentScreen(),
          ),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FlightBottomNavBar(
              currentIndex: _currentIndex,
              onTabSelected: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          key: const ValueKey('home_tab'),
          onSwitchTab: _onTabSelected,
        );
      case 1:
        return ExploreScreen(
          key: const ValueKey('explore_tab'),
          onSwitchTab: _onTabSelected,
        );
      case 2:
        return MyTicketsScreen(
          key: const ValueKey('tickets_tab'),
          onSwitchTab: _onTabSelected,
        );
      case 3:
        return ProfileScreen(
          key: const ValueKey('profile_tab'),
          onSwitchTab: _onTabSelected,
        );
      default:
        return HomeScreen(
          key: const ValueKey('home_tab_default'),
          onSwitchTab: _onTabSelected,
        );
    }
  }
}
