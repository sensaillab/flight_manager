// lib/constants/app_localizations.dart
import 'package:flutter/widgets.dart';

class AppLocalizations {
  static const Map<String, String> _enUS = {
    // General
    'fillAllFields': 'Please fill all fields',
    'requiredField': 'Required',
    'onlyLetters': 'Only letters allowed',
    'cancel': 'Cancel',
    'copyLast': 'Copy Last',

    // Customers
    'customersTitle': 'Customers',
    'noCustomers': 'No customers yet.',
    'addCustomer': 'Add Customer',
    'editCustomer': 'Edit Customer',
    'firstName': 'First Name',
    'lastName': 'Last Name',
    'address': 'Address',
    'dateOfBirth': 'Date of Birth',
    'customerAdded': 'Customer added',
    'customerUpdated': 'Customer updated',
    'customerDeleted': 'Customer deleted',
    'deleteCustomerConfirm': 'Delete this customer?',

    // Airplanes
    'airplanesTitle': 'Airplanes',
    'noAirplanes': 'No airplanes yet.',
    'addAirplane': 'Add Airplane',
    'editAirplane': 'Edit Airplane',
    'airplaneType': 'Airplane Type',
    'passengers': 'Passengers',
    'maxSpeed': 'Max Speed',
    'range': 'Range',
    'airplaneAdded': 'Airplane added',
    'airplaneUpdated': 'Airplane updated',
    'airplaneDeleted': 'Airplane deleted',
    'deleteAirplaneConfirm': 'Delete this airplane?',

    // Flights
    'flightsTitle': 'Flights',
    'noFlights': 'No flights yet.',
    'addFlight': 'Add Flight',
    'editFlight': 'Edit Flight',
    'departureCity': 'Departure City',
    'destinationCity': 'Destination City',
    'departureTime': 'Departure Time',
    'arrivalTime': 'Arrival Time',
    'flightAdded': 'Flight added',
    'flightUpdated': 'Flight updated',
    'flightDeleted': 'Flight deleted',
    'deleteFlightConfirm': 'Delete this flight?',
    'flightHelp':
    'Enter departure & destination cities, pick times, then press Add.',

    // Reservations
    'reservationsTitle': 'Reservations',
    'noReservations': 'No reservations yet.',
    'addReservation': 'Add Reservation',
    'editReservation': 'Edit Reservation',
    'reservationName': 'Reservation Name',
    'customerId': 'Customer ID',
    'flightId': 'Flight ID',
    'reservationDate': 'Date',
    'reservationAdded': 'Reservation added',
    'reservationUpdated': 'Reservation updated',
    'reservationDeleted': 'Reservation deleted',
    'deleteReservationConfirm': 'Delete this reservation?',
    'reservationHelp':
    'Enter customer ID, flight ID, date and name, then press Add.',
  };

  static const Map<String, String> _enGB = {
    ..._enUS,
    // Example UK overrides (if needed)
    // 'color': 'colour'
  };

  static Map<String, String> _localizedMap(Locale locale) {
    if (locale.countryCode == 'GB') return _enGB;
    return _enUS;
  }

  static String of(BuildContext ctx, String key) {
    final locale = Localizations.localeOf(ctx);
    return _localizedMap(locale)[key] ?? key;
  }

}
