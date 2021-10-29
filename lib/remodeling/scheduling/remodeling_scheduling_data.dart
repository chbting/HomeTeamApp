import '../remodeling_items.dart';

class RemodelingSchedulingData {

  final List<RemodelingItem> selectedItemList = [];

  // Painting Card
  int? paintArea;
  bool? scrapeOldPaint;

  // Painting Card
  int? wallCoveringsArea;

  // AC Installation Card
  int? acCount;

  // Removals

  // Suspended Ceiling

  // Toilet Replacement
  String? type;

  // Pest Control

  // Date Picker
  static const firstAvailableDay = 2;
  late DateTime datePicked;

  // Contacts
  String? addressLine1;
  String? addressLine2;
  String? district;
  String? region;
  String? phoneNumber;
  String? lastName;
  String? prefix;

  RemodelingSchedulingData() {
    final now = DateTime.now();
    datePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
  }
}
