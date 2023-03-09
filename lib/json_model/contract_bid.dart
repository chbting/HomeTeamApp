import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/contract.dart';
import 'package:hometeam_client/json_model/tenant.dart';

class ContractBid {
  Contract contract;
  String notes;
  late Tenant tenant;

  ContractBid({required this.contract, this.notes = ''}) {
    tenant = Tenant(address: Address());
  }
}
