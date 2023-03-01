import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tner_client/debug.dart';
import 'package:tner_client/utils/client_data.dart';

import '../remodeling_types.dart';

/// This class contains all the data to be submitted to the server, thus it
/// needs to be JSON serializable
class RemodelingOrder {
  final List<RemodelingItem> remodelingItems;
  final Map<RemodelingItem, List<File>> imageMap = {}; // todo goes into individual item
  late Client client;

  RemodelingOrder({required this.remodelingItems}) {
    kDebugMode ? client = getSampleClientData() : client = Client();
  }
}
