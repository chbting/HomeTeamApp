import 'package:tner_client/properties/property.dart';

class PropertyVisitData {
  final List<Property> propertyList = [];
  final List<Property> propertyVisitSequence = [];

  // Date Picker
  static const firstAvailableDay = 2;
  late DateTime dateTimePicked;

  // Agreement
  bool agreementSigned = false;

  // Contact
  String? phoneNumber;
  String? lastName;
  String? prefix;

  PropertyVisitData() {
    final now = DateTime.now();
    dateTimePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
  }
}
