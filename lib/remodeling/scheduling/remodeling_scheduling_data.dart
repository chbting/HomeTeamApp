import 'dart:io';

import 'package:tner_client/utils/client_data.dart';

import '../remodeling_items.dart';

class RemodelingSchedulingData {
  final List<RemodelingItem> selectedItemList = [];
  final Map<RemodelingItem, File> imageMap = {};

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

  late Client client;

  RemodelingSchedulingData() {
    final now = DateTime.now();
    datePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
    client = Client();
  }
}
