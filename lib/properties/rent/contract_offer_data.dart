import 'package:tner_client/properties/property.dart';

class ContractOffer {

  Property property;
  int? offeredMonthlyRent;
  String? notes;

  // Tenant info
  String? name, prefix, idCardNumber, phoneNumber, emailAddress;

  ContractOffer(this.property);

}