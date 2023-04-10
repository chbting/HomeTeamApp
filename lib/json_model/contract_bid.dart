import 'package:hometeam_client/json_model/contract.dart';
import 'package:hometeam_client/json_model/tenant.dart';

class ContractBid {
  Contract contractOriginal; //todo immutable
  late Contract contractBid;
  Tenant tenant = Tenant();
  String notes;

  ContractBid({required this.contractOriginal, this.notes = ''}) {
    contractBid = contractOriginal.copyWith();
  }
}
