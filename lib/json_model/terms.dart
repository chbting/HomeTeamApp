import 'package:hometeam_client/json_model/expense.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terms.g.dart';

/// Should contains only data goes into the final contract, except reference IDs

@JsonSerializable()
class Terms {
  int propertyId;
  int rent, deposit;

  DateTime earliestStartDate; // earliest start date
  DateTime? latestStartDate;

  // User fills in either lease length or fixed endDate, not both
  DateTime? leaseLength;
  DateTime? leaseEndDate;

  DateTime? gracePeriodStart, gracePeriodEnd;

  PartyType terminationRight; // landlord, tenant, both
  DateTime terminationRightStartDate;
  int terminationNotificationPeriod; // Dates before terminationRightStartDate

  Map<Expense, ExpenseData> expenses = {
    Expense.structure: ExpenseData(landlordPaid: true),
    Expense.fixture: ExpenseData(landlordPaid: true),
    Expense.furniture: ExpenseData(landlordPaid: true),
    Expense.water: ExpenseData(landlordPaid: false),
    Expense.electricity: ExpenseData(landlordPaid: false),
    Expense.gas: ExpenseData(landlordPaid: false),
    Expense.rates: ExpenseData(landlordPaid: true),
    Expense.management: ExpenseData(landlordPaid: true),
  };

  Terms(
      {required this.propertyId,
      this.rent = -1,
      this.deposit = -1,
      DateTime? earliestStartDate,
      this.latestStartDate,
      this.leaseLength,
      this.leaseEndDate,
      this.gracePeriodStart,
      this.gracePeriodEnd,
      this.terminationRight = PartyType.both,
      DateTime? terminationRightStartDate,
      this.terminationNotificationPeriod = -1})
      : earliestStartDate = earliestStartDate ?? DateTime.now(),
        terminationRightStartDate = terminationRightStartDate ?? DateTime.now();

  Terms copyWith(
      {int? propertyId,
      int? rent,
      int? deposit,
      bool? waterRequired,
      bool? electricityRequired,
      bool? gasRequired,
      bool? ratesRequired,
      bool? managementRequired}) {
    return Terms(
      propertyId: propertyId ?? this.propertyId,
      rent: rent ?? this.rent,
      deposit: deposit ?? this.deposit,
    );
  }

  factory Terms.fromJson(Map<String, dynamic> json) => _$TermsFromJson(json);

  Map<String, dynamic> toJson() => _$TermsToJson(this);
}

enum PartyType { landlord, tenant, both }
