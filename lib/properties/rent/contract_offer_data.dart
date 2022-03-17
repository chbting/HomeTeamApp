import 'package:tner_client/properties/property.dart';
import 'package:tner_client/utils/client_data.dart';

class ContractOffer {
  Property property;
  int? offeredMonthlyRent, offeredDeposit;
  String? notes;
  Duration? minLeaseDuration;
  DateTime? startDate, endDate, offeredStartDate, offeredEndDate;

  late Client client;

  // Tenant paid fees
  late bool offeredWater,
      offeredElectricity,
      offeredGas,
      offeredRates,
      offeredManagement;

  ContractOffer(this.property) {
    offeredWater = property.water;
    offeredElectricity = property.electricity;
    offeredGas = property.gas;
    offeredRates = property.rates;
    offeredManagement = property.water;
    client = Client();
  }
}
