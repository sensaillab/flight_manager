import '../dao/airplane_dao.dart';
import '../models/airplane.dart';

class AirplaneRepository {
  final AirplaneDao dao;

  AirplaneRepository(this.dao);

  Future<List<Airplane>> getAllAirplanes() => dao.findAllAirplanes();
  Future<void> addAirplane(Airplane airplane) => dao.insertAirplane(airplane);
  Future<void> updateAirplane(Airplane airplane) => dao.updateAirplane(airplane);
  Future<void> deleteAirplane(Airplane airplane) => dao.deleteAirplane(airplane);
}
