import 'package:flutter/foundation.dart';
import '../data/database.dart';
import '../dao/flight_dao.dart';
import '../models/flight.dart';

class FlightModel extends ChangeNotifier {
  late final FlightDao _dao;
  List<Flight> flights = [];
  bool loading = false;
  String? error;
  bool ready = false;

  FlightModel() {
    _init();
  }

  Future<void> _init() async {
    final db = await $FloorAppDatabase.databaseBuilder('flight_manager.db').build();
    _dao = db.flightDao;
    ready = true;
    await loadAll();
  }

  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      flights = await _dao.findAllFlights();
    } catch (e) {
      error = 'Failed to load flights: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Flight?> findById(int id) async {
    try {
      return await _dao.findFlightById(id);
    } catch (_) {
      return null;
    }
  }

  Future<void> add(Flight f) async => _wrap(() => _dao.insertFlight(f));
  Future<void> update(Flight f) async => _wrap(() => _dao.updateFlight(f));
  Future<void> delete(Flight f) async => _wrap(() => _dao.deleteFlight(f));

  Future<void> _wrap(Future<void> Function() op) async {
    try {
      await op();
      await loadAll();
    } catch (e) {
      error = 'Database error: $e';
      notifyListeners();
    }
  }
}
