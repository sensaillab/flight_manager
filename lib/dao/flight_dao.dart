import 'package:floor/floor.dart';
import '../models/flight.dart';

@dao
abstract class FlightDao {
  @Query('SELECT * FROM Flight ORDER BY id DESC')
  Future<List<Flight>> findAllFlights();

  @Query('SELECT * FROM Flight WHERE id = :id')
  Future<Flight?> findFlightById(int id);

  @insert
  Future<void> insertFlight(Flight flight);

  @update
  Future<void> updateFlight(Flight flight);

  @delete
  Future<void> deleteFlight(Flight flight);
}
