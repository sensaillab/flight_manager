import 'package:flutter/foundation.dart';
import '../data/database.dart';
import '../dao/reservation_dao.dart';
import '../dao/customer_dao.dart';
import '../dao/flight_dao.dart';
import '../models/reservation.dart';
import '../models/customer.dart';
import '../models/flight.dart';

class ReservationModel extends ChangeNotifier {
  late final ReservationDao _reservationDao;
  late final CustomerDao _customerDao;
  late final FlightDao _flightDao;

  List<Reservation> reservations = [];
  bool loading = false;
  String? error;
  bool ready = false;

  ReservationModel() {
    _init();
  }

  Future<void> _init() async {
    final db = await $FloorAppDatabase.databaseBuilder('flight_manager.db').build();
    _reservationDao = db.reservationDao;
    _customerDao = db.customerDao;
    _flightDao = db.flightDao;
    ready = true;
    await loadAll();
  }

  Future<void> loadAll() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      reservations = await _reservationDao.findAllReservations();
    } catch (e) {
      error = 'Failed to load reservations: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Get linked Customer name for a reservation
  Future<String> getCustomerName(int customerId) async {
    final c = await _customerDao.findCustomerById(customerId);
    return c != null ? '${c.firstName} ${c.lastName}' : 'Unknown customer';
  }

  /// Get linked Flight route for a reservation
  Future<String> getFlightRoute(int flightId) async {
    final f = await _flightDao.findFlightById(flightId);
    return f != null ? '${f.departureCity} → ${f.destinationCity}' : 'Unknown flight';
  }

  Future<Reservation?> findById(int id) async {
    try {
      return await _reservationDao.findReservationById(id);
    } catch (_) {
      return null;
    }
  }

  Future<void> add(Reservation r) async => _wrap(() => _reservationDao.insertReservation(r));
  Future<void> update(Reservation r) async => _wrap(() => _reservationDao.updateReservation(r));
  Future<void> delete(Reservation r) async => _wrap(() => _reservationDao.deleteReservation(r));

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
