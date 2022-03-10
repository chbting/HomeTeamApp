import 'package:tner_client/properties/property.dart';

class ContractOffer {
  Property property;
  int? offeredMonthlyRent, offeredDeposit;
  String? notes;
  Duration? minLeaseDuration;
  DateTime? startDate, endDate, offeredStartDate, offeredEndDate;

  // Tenant info
  String? name, prefix, idCardNumber, phoneNumber, emailAddress;

  ContractOffer(this.property);
}
