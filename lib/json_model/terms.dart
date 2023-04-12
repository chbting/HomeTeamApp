import 'package:hometeam_client/json_model/expense.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terms.g.dart';

@JsonSerializable()
class Terms {
  int propertyId;
  int rent, deposit;
  bool rentNegotiable, depositNegotiable;

  DateTime startDate; // earliest start date
  DateTime? latestStartDate;
  bool showLatestStartDate;

  // User fills in either lease length or fixed endDate, not both
  DateTime? leaseLength;
  DateTime? leaseEndDate;

  DateTime? gracePeriodStart, gracePeriodEnd;
  bool showGracePeriod;
  bool gracePeriodNegotiable;

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
      this.rentNegotiable = true,
      this.depositNegotiable = false,
      DateTime? earliestStartDate,
      this.latestStartDate,
      this.showLatestStartDate = false,
      this.leaseLength,
      this.leaseEndDate,
      this.gracePeriodStart,
      this.gracePeriodEnd,
      this.showGracePeriod = false,
      this.gracePeriodNegotiable = false,
      this.terminationRight = PartyType.both,
      DateTime? terminationRightStartDate,
      this.terminationNotificationPeriod = -1})
      : startDate = earliestStartDate ?? DateTime.now(),
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
