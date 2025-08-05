import 'dart:convert';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

/// Helper class for securely storing and retrieving recent form entries
/// using EncryptedSharedPreferences.
class EncryptedPrefsHelper {
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  // Keys for last-used form data
  static const String lastFlightKey = 'last_flight';
  static const String lastReservationKey = 'last_reservation';
  static const String lastCustomerKey = 'last_customer';
  static const String lastAirplaneKey = 'last_airplane';

  static const String _historySuffix = '_history';

  /// Saves the latest values for a given form key, and appends them to history.
  Future<void> saveLast(String key, Map<String, String> values) async {
    for (final entry in values.entries) {
      await _prefs.setString('${key}_${entry.key}', entry.value);
    }
    await appendHistory(key, values);
  }

  /// Loads the most recently saved values for the given fields.
  Future<Map<String, String>> loadLast(String key, List<String> fields) async {
    final result = <String, String>{};
    for (final field in fields) {
      result[field] = await _prefs.getString('${key}_$field') ?? '';
    }
    return result;
  }

  /// Appends the provided values to the history for the given key.
  Future<void> appendHistory(String key, Map<String, String> values) async {
    try {
      final raw = await _prefs.getString('$key$_historySuffix') ?? '[]';
      final List entries = jsonDecode(raw) as List;
      entries.add({
        'timestamp': DateTime.now().toIso8601String(),
        'values': values,
      });
      if (entries.length > 20) entries.removeAt(0); // Keep last 20 entries
      await _prefs.setString('$key$_historySuffix', jsonEncode(entries));
    } catch (_) {
      // If JSON is corrupted, reset history
      await _prefs.setString('$key$_historySuffix', '[]');
    }
  }

  /// Loads history entries that are within the given [maxAge].
  Future<List<Map<String, String>>> loadHistory(String key, Duration maxAge) async {
    try {
      final raw = await _prefs.getString('$key$_historySuffix') ?? '[]';
      final List entries = jsonDecode(raw) as List;
      final cutoff = DateTime.now().subtract(maxAge);
      final result = <Map<String, String>>[];

      for (final e in entries.reversed) {
        final ts = DateTime.tryParse(e['timestamp'] as String);
        if (ts != null && ts.isAfter(cutoff)) {
          final vals = Map<String, String>.from(e['values'] as Map);
          result.add(vals);
        }
      }
      return result;
    } catch (_) {
      return [];
    }
  }

  /// Clears history for a given key.
  Future<void> clearHistory(String key) async {
    await _prefs.setString('$key$_historySuffix', '[]');
  }
}
