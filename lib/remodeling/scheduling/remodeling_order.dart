import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hometeam_client/json_model/remodeling_client.dart';
import 'package:hometeam_client/remodeling/remodeling_types.dart';

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
