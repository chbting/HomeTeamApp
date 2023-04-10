import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/json_model/contract.dart';

class Listing {
  String title;

  // todo listing start/end date etc
  int propertyId;
  Contract contract;

  Listing(
      {required this.title, required this.propertyId, required this.contract});
}
