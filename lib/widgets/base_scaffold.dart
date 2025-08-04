import 'package:flutter/material.dart';
import '../pages/flights_list_page.dart';
import '../pages/reservation_page.dart';
import '../pages/customer_list_page.dart';
import '../pages/airplane_list_page.dart';
import '../pages/home_page.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onFab;
  final IconData fabIcon;
  final VoidCallback? helpAction;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const BaseScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.onFab,
    this.fabIcon = Icons.add,
    this.helpAction,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  void _navigateWithFade(BuildContext context, Widget page) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (helpAction != null)
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: 'Help',
              onPressed: helpAction,
            ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            tooltip: 'Toggle theme',
            onPressed: toggleTheme,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.flight_takeoff),
              title: const Text('Flights'),
              onTap: () => _navigateWithFade(
                context,
                FlightsListPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Reservations'),
              onTap: () => _navigateWithFade(
                context,
                ReservationPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Customers'),
              onTap: () => _navigateWithFade(
                context,
                CustomerListPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.airplanemode_active),
              title: const Text('Airplanes'),
              onTap: () => _navigateWithFade(
                context,
                AirplaneListPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FlightManagerHomePage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: body,

      floatingActionButton: onFab != null
          ? FloatingActionButton(
        onPressed: onFab,
        child: Icon(fabIcon),
      )
          : null,
    );
  }
}
