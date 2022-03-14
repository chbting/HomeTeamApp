import 'package:tner_client/utils/client_data.dart';

import '../remodeling_items.dart';

class RemodelingSchedulingData extends ClientData{

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

  RemodelingSchedulingData() {
    final now = DateTime.now();
    datePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
  }
}
