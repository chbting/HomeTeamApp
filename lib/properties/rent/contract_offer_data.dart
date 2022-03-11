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
  String? name, prefix, idCardNumber, phoneNumber, emailAddress;

  ContractOffer(this.property) {
    offeredWater = property.water;
    offeredElectricity = property.electricity;
    offeredGas = property.gas;
    offeredRates = property.rates;
    offeredManagement = property.water;
  }
}
