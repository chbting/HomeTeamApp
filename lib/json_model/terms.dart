import 'package:easy_stepper/easy_stepper.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/data/expense.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terms.g.dart';

/// Should contains only data goes into the final contract, except reference IDs

@JsonSerializable()
class Terms {
  String propertyId;
  int? rent, deposit;

  DateTime? earliestStartDate, latestStartDate; // earliest start date

  // User fills in either lease length or fixed endDate, not both
  LeasePeriodType leasePeriodType;
  int? leaseLength;
  DateTime? leaseEndDate;

  int? gracePeriod;

  PartyType? terminationRight; // landlord, tenant, both
  DateTime? earliestTerminationDate;
  int? daysNoticeBeforeTermination; // Dates before terminationRightStartDate

  Map<Expense, bool> expenses;

  String? customTerms;

  Terms(
      {required this.propertyId,
      this.rent,
      this.deposit,
      this.earliestStartDate,
      this.latestStartDate,
      this.leasePeriodType = LeasePeriodType.specificLength,
      this.leaseLength,
      this.leaseEndDate,
      this.gracePeriod,
      this.terminationRight,
      this.earliestTerminationDate,
      this.daysNoticeBeforeTermination})
      : expenses = {} {
    for (var expense in Expense.values) {
      expenses[expense] = ExpenseHelper.isPaidByLandlordDefault(expense);
    }
  }

  factory Terms.fromJson(Map<String, dynamic> json) => _$TermsFromJson(json);

  Map<String, dynamic> toJson() => _$TermsToJson(this);
}

enum PartyType { landlord, tenant, both }

class PartyTypeHelper {
  static String getName(BuildContext context, PartyType type) {
    switch (type) {
      case PartyType.landlord:
        return S.of(context).landlord;
      case PartyType.tenant:
        return S.of(context).tenant;
      case PartyType.both:
        return S.of(context).both_party;
    }
  }
}

enum LeasePeriodType { specificLength, specificEndDate }
