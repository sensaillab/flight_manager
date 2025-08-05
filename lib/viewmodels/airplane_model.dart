import 'package:flutter/foundation.dart';
import '../data/database.dart';
import '../dao/airplane_dao.dart';
import '../models/airplane.dart';

class AirplaneModel extends ChangeNotifier {
  late final AirplaneDao _dao;
  List<Airplane> airplanes = [];
  bool loading = false;
  String? error;
  bool ready = false;

  AirplaneModel() {
    _init();
  }

  Future<void> _init() async {
    final db = await $FloorAppDatabase.databaseBuilder('flight_manager.db').build();
    _dao = db.airplaneDao;
    ready = true;
    await loadAll();
  }

  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      airplanes = await _dao.findAllAirplanes();
    } catch (e) {
      error = 'Failed to load airplanes: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Airplane?> findById(int id) async {
    try {
      return await _dao.findAirplaneById(id);
    } catch (_) {
      return null;
    }
  }

  Future<void> add(Airplane a) async => _wrap(() => _dao.insertAirplane(a));
  Future<void> update(Airplane a) async => _wrap(() => _dao.updateAirplane(a));
  Future<void> delete(Airplane a) async => _wrap(() => _dao.deleteAirplane(a));

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
