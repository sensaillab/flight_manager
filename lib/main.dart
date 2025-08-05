import 'package:flutter/material.dart';
import 'constants/themes.dart';
import 'pages/flights_list_page.dart';
import 'pages/reservation_page.dart';
import 'pages/customer_list_page.dart';
import 'pages/airplane_list_page.dart';
import 'utils/encrypted_prefs_helper.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const FlightManagerApp());
}

class FlightManagerApp extends StatefulWidget {
  const FlightManagerApp({Key? key}) : super(key: key);

  @override
  State<FlightManagerApp> createState() => _FlightManagerAppState();
}

class _FlightManagerAppState extends State<FlightManagerApp> {
  bool _isDarkMode = false;
  final _prefs = EncryptedPrefsHelper();

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final stored = await _prefs.loadLast("theme_pref", ["isDarkMode"]);
    setState(() {
      _isDarkMode = stored["isDarkMode"] == "true";
    });
  }

  Future<void> _saveThemePreference(bool isDark) async {
    await _prefs.saveLast("theme_pref", {
      "isDarkMode": isDark.toString(),
    });
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
    _saveThemePreference(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Manager',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('en', 'GB'),
      ],
      routes: {
        '/flights': (context) =>
            FlightsListPage(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
        '/reservations': (context) =>
            ReservationPage(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
        '/customers': (context) =>
            CustomerListPage(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
        '/airplanes': (context) =>
            AirplaneListPage(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      },
      home: FlightManagerHomePage(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}
