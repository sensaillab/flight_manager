import '../dao/flight_dao.dart';
import '../models/flight.dart';

class FlightRepository {
  final FlightDao dao;

  FlightRepository(this.dao);

  Future<List<Flight>> getAllFlights() => dao.findAllFlights();
  Future<void> addFlight(Flight flight) => dao.insertFlight(flight);
  Future<void> updateFlight(Flight flight) => dao.updateFlight(flight);
  Future<void> deleteFlight(Flight flight) => dao.deleteFlight(flight);
}
