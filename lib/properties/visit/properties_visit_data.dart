import '../property.dart';

class PropertiesVisitData {

  final List<Property> selectedItemList = [];

  // Date Picker
  static const firstAvailableDay = 2;
  late DateTime datePicked;

  // Contacts
  String? phoneNumber;
  String? lastName;
  String? prefix;

  PropertiesVisitData() {
    final now = DateTime.now();
    datePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
  }
}
