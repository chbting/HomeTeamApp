import 'package:tner_client/properties/property.dart';
import 'package:tner_client/utils/client_data.dart';

class ContractOffer extends ClientData {
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
  String? idCardNumber, emailAddress;

  ContractOffer(this.property) {
    offeredWater = property.water;
    offeredElectricity = property.electricity;
    offeredGas = property.gas;
    offeredRates = property.rates;
    offeredManagement = property.water;
  }
}
