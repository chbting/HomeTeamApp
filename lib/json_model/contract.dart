import 'package:hometeam_client/json_model/expenditure.dart';

class Contract {
  int propertyId;
  int rent;
  int deposit;

  // todo serializable
  DateTime? startDate, endDate;

  String gracePeriodStart; // todo string <-> datetime conversion
  String gracePeriodEnd;
  String terminationRight; // landlord, tenant, both
  String terminationRightStartDate;
  int terminationNotificationPeriod; // Dates before terminationRightStartDate

  Expenditure structure,
      fixture,
      furniture,
      water,
      electricity,
      gas,
      rates,
      management;

  Contract({required this.propertyId, this.rent = -1, this.deposit = -1})
      : structure =
            Expenditure(type: ExpenditureType.structure, landlordPay: true),
        fixture =
            Expenditure(type: ExpenditureType.structure, landlordPay: true),
        furniture =
            Expenditure(type: ExpenditureType.structure, landlordPay: true),
        water =
            Expenditure(type: ExpenditureType.structure, landlordPay: false),
        electricity =
            Expenditure(type: ExpenditureType.structure, landlordPay: false),
        gas = Expenditure(type: ExpenditureType.structure, landlordPay: false),
        rates = Expenditure(type: ExpenditureType.structure, landlordPay: true),
        management =
            Expenditure(type: ExpenditureType.structure, landlordPay: true);

  Contract copyWith(
      {int? propertyId,
      int? rent,
      int? deposit,
      bool? waterRequired,
      bool? electricityRequired,
      bool? gasRequired,
      bool? ratesRequired,
      bool? managementRequired}) {
    return Contract(
      propertyId: propertyId ?? this.propertyId,
      rent: rent ?? this.rent,
      deposit: deposit ?? this.deposit,
    );
  }
}
