import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/expense.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/shared/date_picker_form_field.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_card.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/shared/ui/terms_item.dart';

class LeaseTermsWidget extends StatefulWidget {
  const LeaseTermsWidget({Key? key, required this.controller})
      : super(key: key);

  final FormController controller;

  @override
  State<StatefulWidget> createState() => LeaseTermsWidgetState();
}

class LeaseTermsWidgetState extends State<LeaseTermsWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateTime _today = DateUtils.dateOnly(DateTime.now());
  late DateTime _withinOneYearFromToday;

  late Listing _listing;
  late Terms _terms;

  @override
  void initState() {
    widget.controller.reset = _reset;
    widget.controller.validate = _validate;
    _withinOneYearFromToday =
        _today.copyWith(year: _today.year + 1, day: _today.day - 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _listing = ListingInheritedData.of(context)!.listing;
    _terms = ListingInheritedData.of(context)!.terms;
    return Form(
        key: _formKey,
        child: ListView(
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: StandardStepper.bottomMargin),
          children: [
            _getRentSection(context),
            _getLeasePeriodSection(context),
            _getExpensesSection(context),
          ],
        ));
  }

  Widget _getRentSection(BuildContext context) {
    return FormCard(
      title: S.of(context).rent,
      body: Wrap(
        runSpacing: 16.0,
        children: [
          TermsItemWidget.getTitleBar(context),
          TermsItemWidget(
              termsItemSettings: _listing.settings[TermsItem.rent]!,
              child: TextFormField(
                  initialValue: _terms.rent?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).monthly_rent),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_put_in_a_valid_amount;
                    } else {
                      _terms.rent = int.parse(value);
                      return null;
                    }
                  })),
          TermsItemWidget(
              termsItemSettings: _listing.settings[TermsItem.deposit]!,
              child: TextFormField(
                  initialValue: _terms.deposit?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).deposit),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_put_in_a_valid_amount;
                    } else {
                      _terms.deposit = int.parse(value);
                      return null;
                    }
                  })),
        ],
      ),
    );
  }

//todo almost every line is too long to show in english
  Widget _getLeasePeriodSection(BuildContext context) {
    return FormCard(
      title: S.of(context).lease_period,
      body: Wrap(
        runSpacing: 16.0,
        children: [
          TermsItemWidget.getTitleBar(context),
          TermsItemWidget(
              termsItemSettings:
                  _listing.settings[TermsItem.earliestStartDate]!,
              child: DatePickerFormField(
                labelText: S.of(context).lease_earliest_start_date,
                pickerHelpText: S.of(context).lease_earliest_start_date,
                initialDate: _terms.earliestStartDate,
                firstDate: _today,
                lastDate: _withinOneYearFromToday,
                onChanged: (DateTime dateTime) =>
                    setState(() => _terms.earliestStartDate = dateTime),
                validator: (DateTime? dateTime) {
                  return dateTime == null
                      ? S.of(context).please_put_in_a_valid_date
                      : null;
                },
              )),
          TermsItemWidget(
              //todo make optional
              termsItemSettings: _listing.settings[TermsItem.latestStartDate]!,
              child: DatePickerFormField(
                labelText: S.of(context).lease_latest_start_date,
                pickerHelpText: S.of(context).lease_latest_start_date,
                initialDate: _terms.latestStartDate,
                firstDate: _terms.earliestStartDate ?? _today,
                lastDate: _withinOneYearFromToday,
                validator: (DateTime? dateTime) {
                  if (dateTime == null) {
                    return S.of(context).please_put_in_a_valid_date;
                  } else {
                    if (_terms.earliestStartDate != null) {
                      if (dateTime.isBefore(_terms.earliestStartDate!)) {
                        //todo text is too long to show
                        return S.of(context).msg_input_before_earliest_start;
                      }
                    }
                    _terms.latestStartDate = dateTime;
                    return null;
                  }
                },
              )),
          const Divider(thickness: 1.0),
          Row(children: [
            Radio<LeasePeriodType>(
                value: LeasePeriodType.specificLength,
                groupValue: _terms.leasePeriodType,
                onChanged: (value) => setState(() {
                      _terms.leasePeriodType = value!;
                      //todo disable/enable textfield
                    })),
            Expanded(
              child: TextFormField(
                  enabled:
                      _terms.leasePeriodType == LeasePeriodType.specificLength,
                  initialValue: _terms.leaseLength?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).lease_length_months),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_put_in_a_valid_amount;
                    } else {
                      _terms.leaseLength = int.parse(value);
                      return null;
                    }
                  }),
            )
          ]),
          Row(children: [
            Radio<LeasePeriodType>(
                value: LeasePeriodType.specificEndDate,
                groupValue: _terms.leasePeriodType,
                onChanged: (value) => setState(() {
                      _terms.leasePeriodType = value!;
                    })),
            Expanded(
              child: DatePickerFormField(
                labelText: S.of(context).lease_end_date,
                pickerHelpText: S.of(context).lease_end_date,
                initialDate: _terms.leaseEndDate,
                firstDate: _terms.earliestStartDate ?? _today,
                lastDate: _today.copyWith(year: _today.year + 3),
                enabled:
                    _terms.leasePeriodType == LeasePeriodType.specificEndDate,
                validator: (DateTime? dateTime) {
                  if (dateTime == null) {
                    return S.of(context).please_put_in_a_valid_date;
                  } else {
                    if (_terms.earliestStartDate != null) {
                      if (dateTime.isBefore(_terms.earliestStartDate!)) {
                        //todo text is too long to show
                        return S.of(context).msg_input_before_earliest_start;
                      }
                    }
                    _terms.latestStartDate = dateTime;
                    return null;
                  }
                },
              ),
            )
          ]),
          const Divider(thickness: 1.0),
          TermsItemWidget(
              termsItemSettings: _listing.settings[TermsItem.gracePeriod]!,
              child: TextFormField(
                  initialValue: _terms.deposit?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).grace_period_days),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_put_in_a_valid_amount;
                    } else {
                      _terms.gracePeriod = int.parse(value);
                      return null;
                    }
                  })),
          TermsItemWidget(
              termsItemSettings: _listing.settings[TermsItem.terminationRight]!,
              child: DropdownButtonFormField<PartyType>(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).early_termination_right),
                  isExpanded: true,
                  value: _terms.terminationRight,
                  onChanged: (PartyType? newValue) =>
                      setState(() => _terms.terminationRight = newValue!),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value == null ? S.of(context).msg_info_required : null,
                  items: PartyType.values
                      .map<DropdownMenuItem<PartyType>>((PartyType value) {
                    return DropdownMenuItem<PartyType>(
                      value: value,
                      child: Text(PartyTypeHelper.getName(context, value)),
                    );
                  }).toList())),
          TermsItemWidget(
              termsItemSettings:
                  _listing.settings[TermsItem.earliestTerminationDate]!,
              child: DatePickerFormField(
                labelText: S.of(context).earliest_termination_day,
                pickerHelpText: S.of(context).earliest_termination_day,
                initialDate: _terms.earliestTerminationDate,
                firstDate: _terms.earliestStartDate ?? _today,
                lastDate: _today.copyWith(year: _today.year + 3),
                validator: (DateTime? dateTime) {
                  if (dateTime == null) {
                    return S.of(context).please_put_in_a_valid_date;
                  } else {
                    if (_terms.earliestStartDate != null) {
                      if (dateTime.isBefore(_terms.earliestStartDate!)) {
                        return S.of(context).msg_input_before_earliest_start;
                      }
                    }
                    _terms.latestStartDate = dateTime;
                    return null;
                  }
                },
              )),
          TermsItemWidget(
              termsItemSettings:
                  _listing.settings[TermsItem.daysNoticeBeforeTermination]!,
              child: TextFormField(
                  initialValue:
                      _terms.daysNoticeBeforeTermination?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).termination_notice_days,
                      helperText: S.of(context).termination_notice_helper_text),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_put_in_a_valid_amount;
                    } else {
                      _terms.gracePeriod = int.parse(value);
                      return null;
                    }
                  }))
        ],
      ),
    );
  }

  Widget _getExpensesSection(BuildContext context) {
    return FormCard(
        title: S.of(context).landlord_expenses,
        body: Wrap(
          runSpacing: 16.0,
          children: [
            TermsItemWidget.getTitleBar(context),
            const TermExpenseItem(
                expense: Expense.structure, termsItem: TermsItem.structure),
            const TermExpenseItem(
                expense: Expense.fixture, termsItem: TermsItem.fixture),
            const TermExpenseItem(
                expense: Expense.furniture, termsItem: TermsItem.furniture),
            const TermExpenseItem(
                expense: Expense.water, termsItem: TermsItem.water),
            const TermExpenseItem(
                expense: Expense.electricity, termsItem: TermsItem.electricity),
            const TermExpenseItem(
                expense: Expense.gas, termsItem: TermsItem.gas),
            const TermExpenseItem(
                expense: Expense.rates, termsItem: TermsItem.rates),
            const TermExpenseItem(
                expense: Expense.management, termsItem: TermsItem.management),
            //todo line is too long for english
          ],
        ));
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {});
  }

  bool _validate() => _formKey.currentState!.validate();
}
