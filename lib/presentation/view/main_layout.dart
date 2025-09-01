import 'package:flutter/material.dart';
import 'package:music_app/presentation/view/favorites_view.dart';
import 'package:music_app/presentation/view/home_view.dart';
import 'package:music_app/presentation/view/settings_view.dart';
import 'package:music_app/presentation/widgets/custom_bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _navbarOptions = const [
    HomeView(),
    FavoritesView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Stack(
          children: [
            // Show selected screen using IndexedStack to preserve state
            IndexedStack(index: _selectedIndex, children: _navbarOptions),

            // Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(
                currentIndex: _selectedIndex,
                onTap: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}