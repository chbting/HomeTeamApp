import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/data/expense.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/json_model/terms_item.dart';
import 'package:hometeam_client/shared/date_picker_form_field.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/shared/ui/terms_item_widget.dart';

class LeaseTermsWidget extends StatefulWidget {
  const LeaseTermsWidget({Key? key, required this.controller})
      : super(key: key);

  final FormController controller;

  @override
  State<StatefulWidget> createState() => LeaseTermsWidgetState();
}

class LeaseTermsWidgetState extends State<LeaseTermsWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final double _leadingPadding = 48.0;
  final DateTime _today = DateUtils.dateOnly(DateTime.now());
  bool _latestStartDateEnabled = false;
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
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: StandardStepper.bottomMargin),
          children: [
            _getRentSection(context),
            const Divider(),
            _getLeasePeriodSection(context),
            const Divider(),
            _getExpensesSection(context),
            // todo a section of provided electrical appliances
            // todo move negotiable, show to tenant checkboxes to "create listing"?
          ],
        ));
  }

  Widget _getRentSection(BuildContext context) {
    return Wrap(
      runSpacing: 8.0,
      children: [
        StandardStepper.getSectionTitle(context, S.of(context).rent,
            bottomPadding: 0.0),
        Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child:
                  Text(S.of(context).negotiable, textAlign: TextAlign.center),
            )),
        ListTile(
            contentPadding: EdgeInsets.zero,
            trailing: Checkbox(
                value: _listing.settings[TermsItem.rent]!.negotiable,
                onChanged: (value) => setState(() =>
                    _listing.settings[TermsItem.rent]!.negotiable = value!)),
            title: TextFormField(
                //todo comma separated numbers
                initialValue: _terms.rent?.toString() ?? '',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    icon: SizedBox(
                        width: _leadingPadding,
                        child: const Icon(Icons.monetization_on)),
                    prefix: const Text('\$ '),
                    labelText: S.of(context).monthly_rent),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).please_put_in_a_valid_amount;
                  } else {
                    _terms.rent = int.parse(value);
                    return null;
                  }
                })),
        ListTile(
            contentPadding: EdgeInsets.zero,
            trailing: Checkbox(
                value: _listing.settings[TermsItem.deposit]!.negotiable,
                onChanged: (value) => setState(() =>
                    _listing.settings[TermsItem.deposit]!.negotiable = value!)),
            title: TextFormField(
                initialValue: _terms.deposit?.toString() ?? '',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    icon: SizedBox(
                        width: _leadingPadding,
                        child: const Icon(Icons.savings)),
                    prefix: const Text('\$ '),
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
    );
  }

  Widget _getLeasePeriodSection(BuildContext context) {
    return Wrap(
      runSpacing: 8.0,
      children: [
        StandardStepper.getSectionTitle(context, S.of(context).lease_period,
            bottomPadding: 0.0),
        _getStartDateSubSection(context),
        const Divider(thickness: 1.0),
        _getLeaseLengthSubSection(context),
        const Divider(thickness: 1.0),
        _getLeasePeriodOptionalItems(context)
      ],
    );
  }

  Widget _getStartDateSubSection(BuildContext context) {
    return Wrap(runSpacing: 8.0, children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(width: _leadingPadding),
        title: DatePickerFormField(
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
        ),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Checkbox(
            //todo clear error text before disabling
            value: _latestStartDateEnabled,
            onChanged: (value) =>
                setState(() => _latestStartDateEnabled = value!)),
        title: DatePickerFormField(
          enabled: _latestStartDateEnabled,
          labelText: S.of(context).lease_latest_start_date,
          pickerHelpText: S.of(context).lease_latest_start_date,
          initialDate: _terms.latestStartDate,
          firstDate: _terms.earliestStartDate ?? _today,
          lastDate: _withinOneYearFromToday,
          validator: (DateTime? dateTime) {
            if (dateTime == null) {
              return S.of(context).please_put_in_a_valid_date;
            } else if (_terms.earliestStartDate != null) {
              if (dateTime.isBefore(_terms.earliestStartDate!)) {
                return S.of(context).msg_input_before_earliest_start;
              }
            }
            _terms.latestStartDate = dateTime;
            return null;
          },
        ),
      )
    ]);
  }

  Widget _getLeaseLengthSubSection(BuildContext context) {
    return Wrap(runSpacing: 8.0, children: [
      CheckboxListTile(
        contentPadding: EdgeInsets.only(left: _leadingPadding),
        title: Align(
            alignment: Alignment.centerRight,
            child: Text(S.of(context).negotiable)),
        value: _listing.settings[TermsItem.leasePeriod]!.negotiable,
        onChanged: (value) => setState(() =>
            _listing.settings[TermsItem.leasePeriod]!.negotiable = value!),
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Radio<LeasePeriodType>(
            value: LeasePeriodType.specificLength,
            groupValue: _terms.leasePeriodType,
            onChanged: (value) =>
                setState(() => _terms.leasePeriodType = value!)),
        title: TextFormField(
            enabled: _terms.leasePeriodType == LeasePeriodType.specificLength,
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
      ),
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Radio<LeasePeriodType>(
            value: LeasePeriodType.specificEndDate,
            groupValue: _terms.leasePeriodType,
            onChanged: (value) =>
                setState(() => _terms.leasePeriodType = value!)),
        title: DatePickerFormField(
          labelText: S.of(context).lease_end_date,
          pickerHelpText: S.of(context).lease_end_date,
          initialDate: _terms.leaseEndDate,
          firstDate: _terms.earliestStartDate ?? _today,
          lastDate: _today.copyWith(year: _today.year + 3),
          enabled: _terms.leasePeriodType == LeasePeriodType.specificEndDate,
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
        ),
      ),
    ]);
  }

  Widget _getLeasePeriodOptionalItems(BuildContext context) {
    return Wrap(runSpacing: 8.0, children: [
      TermsItemWidget.getTitleBar(context),
      // note: add 4 vertical padding to match minVerticalPadding of ListTile
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: TermsItemWidget(
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
              }),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: TermsItemWidget(
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
      ),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: TermsItemWidget(
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
              ))),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: TermsItemWidget(
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
                  })))
    ]);
  }

  Widget _getExpensesSection(BuildContext context) {
    return Wrap(
      runSpacing: 8.0,
      children: [
        StandardStepper.getSectionTitle(
            context, S.of(context).expenses_paid_by_the_landlord_except,
            bottomPadding: 0.0),
        TermsItemWidget.getTitleBar(context),
        const TermsItemCheckBoxListTile(
            expense: Expense.structure, termsItem: TermsItem.structure),
        const TermsItemCheckBoxListTile(
            expense: Expense.fixture, termsItem: TermsItem.fixture),
        const TermsItemCheckBoxListTile(
            expense: Expense.furniture, termsItem: TermsItem.furniture),
        const TermsItemCheckBoxListTile(
            expense: Expense.electricalAppliances,
            termsItem: TermsItem.electricalAppliances),
        const TermsItemCheckBoxListTile(
            expense: Expense.water, termsItem: TermsItem.water),
        const TermsItemCheckBoxListTile(
            expense: Expense.electricity, termsItem: TermsItem.electricity),
        const TermsItemCheckBoxListTile(
            expense: Expense.gas, termsItem: TermsItem.gas),
        const TermsItemCheckBoxListTile(
            expense: Expense.rates, termsItem: TermsItem.rates),
        const TermsItemCheckBoxListTile(
            expense: Expense.management, termsItem: TermsItem.management),
      ],
    );
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {});
  }

  bool _validate() => _formKey.currentState!.validate();
}
