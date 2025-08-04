import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
import '../constants/themes.dart';

class FlightManagerHomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const FlightManagerHomePage({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Flight Manager',
      toggleTheme: toggleTheme,
      isDarkMode: isDarkMode,
      helpAction: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              'About This Project',
              style: TextStyle(
                color: AppThemes.darkYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Welcome to our Final Project Product for CST2335.\n\n'
                  'Our team consists of:\n'
                  '• Said Lhor (041127095) - Project Leader, Github Manager, Task Division, Reservation Page Developer\n'
                  '• Tien Sy Pham (041119478) - Project Setup, Code Structure Division, Flight Page Developer, Designer, Home Page Developer\n'
                  '• Austin Warwick (041143988) - Airplane Page Developer, Colors Management, Directory Management\n'
                  '• Mihiryatinbh Mistry (041105676) - Customer Page Developer, Widgets Management, Database Management',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: AppThemes.darkYellow),
                ),
              ),
            ],
          ),
        );
      },
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/dark_plane.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.4)),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Welcome to Flight Management Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
