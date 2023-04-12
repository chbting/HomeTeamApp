import 'package:hometeam_client/json_model/expense.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terms.g.dart';

@JsonSerializable()
class Terms {
  int propertyId;
  int rent, deposit;
  bool rentNegotiable, depositNegotiable;

  DateTime earliestStartDate;
  DateTime? latestStartDate;
  bool showLatestStartDate;

  // User fills in either lease length or fixed endDate, not both
  DateTime? leaseLength;
  DateTime? endDate;

  DateTime? gracePeriodStart, gracePeriodEnd;
  bool showGracePeriod;
  bool gracePeriodNegotiable;

  PartyType terminationRight; // landlord, tenant, both
  DateTime terminationRightStartDate;
  int terminationNotificationPeriod; // Dates before terminationRightStartDate

  List<Expense> expenses = [
    Expense(type: ExpenseType.structure, landlordPay: true),
    Expense(type: ExpenseType.fixture, landlordPay: true),
    Expense(type: ExpenseType.furniture, landlordPay: true),
    Expense(type: ExpenseType.water, landlordPay: false),
    Expense(type: ExpenseType.electricity, landlordPay: false),
    Expense(type: ExpenseType.gas, landlordPay: false),
    Expense(type: ExpenseType.rates, landlordPay: true),
    Expense(type: ExpenseType.management, landlordPay: true)
  ];

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
      this.endDate,
      this.gracePeriodStart,
      this.gracePeriodEnd,
      this.showGracePeriod = false,
      this.gracePeriodNegotiable = false,
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
