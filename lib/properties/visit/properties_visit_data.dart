import '../property.dart';

class PropertiesVisitData {

  final List<Property> propertyList = [];
  int? startingPropertyId;

  // Date Picker
  static const firstAvailableDay = 2;
  late DateTime dateTimePicked;

  // Contact
  String? phoneNumber;
  String? lastName;
  String? prefix;

  PropertiesVisitData() {
    final now = DateTime.now();
    dateTimePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
  }
}
