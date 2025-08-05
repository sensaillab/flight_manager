// lib/constants/strings.dart
import 'package:flutter/widgets.dart';

class Strings {
  static const Map<String, String> _enUS = {
    // Flight
    'addFlight': 'Add Flight',
    'editFlight': 'Edit Flight',
    'departureCity': 'Departure City',
    'destinationCity': 'Destination City',
    'departureTime': 'Departure Time',
    'arrivalTime': 'Arrival Time',
    'noFlights': 'No flights yet.',
    'flightsTitle': 'Flights',
    'flightAdded': 'Flight added',
    'flightUpdated': 'Flight updated',
    'flightDeleted': 'Flight deleted',
    'deleteFlightConfirm': 'Delete this flight?',
    'flightHelp': 'This page allows you to manage flights.\n\n'
        '• Tap the + button to add a new flight.\n'
        '• Tap the pencil icon to edit an existing flight.\n'
        '• Tap the trash icon to delete a flight.\n'
        '• Enter valid Departure and Destination cities (letters only).\n'
        '• Use the clock icon to set departure and arrival times.\n'
        '• In “Add Flight” mode, you can copy the last saved flight details.',


    // Reservation
    'addReservation': 'Add Reservation',
    'editReservation': 'Edit Reservation',
    'reservationName': 'Reservation Name',
    'customerId': 'Customer ID',
    'flightId': 'Flight ID',
    'reservationDate': 'Date',
    'reservationHelp': 'This page allows you to manage reservations.\n\n'
        '• Tap the + button to add a new reservation.\n'
        '• Select a customer and a flight from the dropdown lists.\n'
        '• Enter a reservation name.\n'
        '• Use the calendar icon to select a reservation date.\n'
        '• Tap the pencil icon to edit an existing reservation.\n'
        '• Tap the trash icon to delete a reservation.',
    'reservationsTitle': 'Reservations',
    'noReservations': 'No reservations yet.',
    'reservationAdded': 'Reservation added',
    'reservationUpdated': 'Reservation updated',
    'reservationDeleted': 'Reservation deleted',
    'deleteReservationConfirm': 'Delete this reservation?',


    // Customer
    'addCustomer': 'Add Customer',
    'editCustomer': 'Edit Customer',
    'firstName': 'First Name',
    'lastName': 'Last Name',
    'address': 'Address',
    'dateOfBirth': 'Date of Birth',
    'customersTitle': 'Customers',
    'noCustomers': 'No customers yet.',
    'customerHelp': 'This page allows you to manage customers.\n\n'
        '• Tap the + button to add a new customer.\n'
        '• Enter First Name, Last Name, and Address.\n'
        '• Use the calendar icon to set the Date of Birth.\n'
        '• Tap the pencil icon to edit an existing customer.\n'
        '• Tap the trash icon to delete a customer.\n'
        '• In “Add Customer” mode, you can copy the last saved customer details.',
    'customerAdded': 'Customer added',
    'customerUpdated': 'Customer updated',
    'customerDeleted': 'Customer deleted',
    'deleteCustomerConfirm': 'Delete this customer?',

    // Airplane
    'addAirplane': 'Add Airplane',
    'editAirplane': 'Edit Airplane',
    'type': 'Type',
    'passengers': 'Passengers',
    'maxSpeed': 'Max Speed',
    'range': 'Range',
    'airplanesTitle': 'Airplanes',
    'noAirplanes': 'No airplanes yet.',
    'airplaneAdded': 'Airplane added',
    'airplaneUpdated': 'Airplane updated',
    'airplaneDeleted': 'Airplane deleted',
    'deleteAirplaneConfirm': 'Delete this airplane?',
    'airplaneHelp': 'This page allows you to manage airplanes.\n\n'
        '• Tap the + button to add a new airplane.\n'
        '• Enter Airplane Type, Passenger Capacity, Max Speed, and Range.\n'
        '• Tap the pencil icon to edit an existing airplane.\n'
        '• Tap the trash icon to delete an airplane.\n'
        '• In “Add Airplane” mode, you can copy the last saved airplane details.',

    // General Validation & Messages
    'fillAllFields': 'Please fill all fields',
    'requiredField': 'Required',
    'onlyLetters': 'Only letters allowed',
    'onlyNumbers': 'Only numbers allowed',
    'invalidNumber': 'Invalid number format',
    'cancel': 'Cancel',
    'ok': 'OK',
    'copyLast': 'Copy Last',
  };

  static const Map<String, String> _enGB = {
    ..._enUS,
    // Example UK overrides:
    // 'color': 'colour'
  };

  static Map<String, String> localizedMap(Locale locale) {
    if (locale.countryCode == 'GB') return _enGB;
    return _enUS;
  }

  static String of(BuildContext ctx, String key) {
    final locale = Localizations.localeOf(ctx);
    return localizedMap(locale)[key] ?? key;
  }
}
