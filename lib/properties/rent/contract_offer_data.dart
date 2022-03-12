import 'package:tner_client/properties/property.dart';

class ContractOffer {
  Property property;
  int? offeredMonthlyRent, offeredDeposit;
  String? notes;
  Duration? minLeaseDuration;
  DateTime? startDate, endDate, offeredStartDate, offeredEndDate;

  // Tenant paid fees
  late bool offeredWater,
      offeredElectricity,
      offeredGas,
      offeredRates,
      offeredManagement;

  // Tenant info
  String? firstName, lastName, prefix, idCardNumber, phoneNumber, emailAddress;
  String? addressLine1, addressLine2, district, region;

  ContractOffer(this.property) {
    offeredWater = property.water;
    offeredElectricity = property.electricity;
    offeredGas = property.gas;
    offeredRates = property.rates;
    offeredManagement = property.water;
  }
}
