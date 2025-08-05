import 'package:flutter/material.dart';
import '../widgets/base_scaffold.dart';
class AppThemes {
  static const Color darkPurple = Color(0xFF1B003D); // Deep night-sky purple
  static const Color darkBrown = Color(0xFF4E342E);   // Deep brown
  static const Color darkYellow = Color(0xFFFFC857); // Dark gold/yellow

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: darkPurple,
    scaffoldBackgroundColor: Colors.white,

    iconTheme: const IconThemeData(color: darkPurple),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(darkPurple),
        overlayColor: MaterialStateProperty.all(darkYellow.withOpacity(0.2)), // ripple
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkPurple,
      foregroundColor: Colors.white,
      elevation: 2,
    ),

    colorScheme: const ColorScheme.light(
      primary: darkPurple,
      secondary: darkYellow,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkPurple,
      foregroundColor: Colors.white,
      splashColor: darkYellow.withOpacity(0.3),
      hoverColor: darkYellow.withOpacity(0.2),
    ),

    timePickerTheme: const TimePickerThemeData(
      dialHandColor: darkPurple,
      dialBackgroundColor: Colors.white,
      hourMinuteTextColor: Colors.black,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkYellow,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPurple,
    scaffoldBackgroundColor: darkPurple,

    iconTheme: const IconThemeData(color: darkYellow),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(darkYellow),
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.2)), // ripple
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkPurple,
      foregroundColor: Colors.white,
      elevation: 2,
    ),

    colorScheme: const ColorScheme.dark(
      primary: darkPurple,
      secondary: darkYellow,
    ),

    timePickerTheme: const TimePickerThemeData(
      dialHandColor: darkYellow,
      dialBackgroundColor: darkBrown,
      hourMinuteTextColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkYellow,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkYellow,
      foregroundColor: Colors.black,
      splashColor: Colors.white.withOpacity(0.3),
      hoverColor: Colors.white.withOpacity(0.2),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkYellow),
      bodyMedium: TextStyle(color: darkYellow),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkYellow,
      ),
    ),
  );
}
