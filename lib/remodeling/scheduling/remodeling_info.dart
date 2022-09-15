import 'dart:io';

import 'package:tner_client/utils/client_data.dart';

import '../remodeling_items.dart';

/// This class contains the data to be submitted to the server
class RemodelingInfo {
  final List<RemodelingItem> remodelingItems;
  final Map<RemodelingItem, List<File>> imageMap = {};

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

  RemodelingInfo({required this.remodelingItems}) {
    final now = DateTime.now();
    datePicked = DateTime(now.year, now.month, now.day + firstAvailableDay);
    client = Client();
    for (var item in remodelingItems) {
      if (RemodelingItemHelper.isPictureRequired(item)) {
        imageMap[item] = [];
      }
    }
  }
}
