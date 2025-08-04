import '../dao/reservation_dao.dart';
import '../models/reservation.dart';

class ReservationRepository {
  final ReservationDao dao;

  ReservationRepository(this.dao);

  Future<List<Reservation>> getAllReservations() => dao.findAllReservations();
  Future<void> addReservation(Reservation reservation) => dao.insertReservation(reservation);
  Future<void> updateReservation(Reservation reservation) => dao.updateReservation(reservation);
  Future<void> deleteReservation(Reservation reservation) => dao.deleteReservation(reservation);
}
