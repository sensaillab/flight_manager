import 'package:floor/floor.dart';
import '../models/reservation.dart';

@dao
abstract class ReservationDao {
  @Query('SELECT * FROM Reservation ORDER BY id DESC')
  Future<List<Reservation>> findAllReservations();

  @Query('SELECT * FROM Reservation WHERE id = :id')
  Future<Reservation?> findReservationById(int id);

  @insert
  Future<void> insertReservation(Reservation reservation);

  @update
  Future<void> updateReservation(Reservation reservation);

  @delete
  Future<void> deleteReservation(Reservation reservation);
}
