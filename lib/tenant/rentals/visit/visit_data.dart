

import 'package:hometeam_client/json_model/listing.dart';

class VisitData {
  final List<Listing> listings;

  // Sequencer
  final List<Listing> optimizedPath;
  final List<Listing> selectedPath;
  final Map<Listing, Map<Listing, int>> travelMap;

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
      {required this.listings,
      required this.optimizedPath,
      required this.selectedPath,
      required this.travelMap}) {
    final now = DateTime.now();
    dateTimePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
  }
}
