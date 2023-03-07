import 'package:hometeam_client/tenant/rentals/property.dart';

class VisitData {
  final List<Property> properties;

  // Sequencer
  final List<Property> optimizedPath;
  final List<Property> selectedPath;
  final Map<Property, Map<Property, int>> travelMap;

  // Date Picker
  static const firstAvailableDay = 1;
  late DateTime dateTimePicked;

  // Agreement
  bool agreementSigned = false;

  // Contact
  String? phoneNumber;
  String? lastName;
  String? prefix;

  VisitData(
      {required this.properties,
      required this.optimizedPath,
      required this.selectedPath,
      required this.travelMap}) {
    final now = DateTime.now();
    dateTimePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
  }
}
