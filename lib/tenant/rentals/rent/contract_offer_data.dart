import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/data/tenant.dart';

class ContractOffer {
  Property property;
  int? offeredMonthlyRent, offeredDeposit;
  String? notes;
  Duration? minLeaseDuration;
  DateTime? startDate, endDate, offeredStartDate, offeredEndDate;

  late Tenant tenant;

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
    tenant = Tenant();
  }
}
