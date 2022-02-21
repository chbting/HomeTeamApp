import '../property.dart';

class PropertiesVisitData {

  final List<Property> selectedProperties = [];

  // Date Picker
  static const firstAvailableDay = 2;
  late DateTime dateTimePicked;

  // Contacts
  String? phoneNumber;
  String? lastName;
  String? prefix;

  PropertiesVisitData() {
    final now = DateTime.now();
    dateTimePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
  }
}
