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
  late Listing _listing;
  late Terms _terms;

  @override
  void initState() {
    widget.controller.reset = _reset;
    widget.controller.validate = _validate;
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
            _getRentalPeriodSection(context),
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
                  initialValue:
                      _terms.rent == -1 ? null : _terms.rent.toString(),
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
                  initialValue:
                      _terms.deposit == -1 ? null : _terms.deposit.toString(),
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

  Widget _getRentalPeriodSection(BuildContext context) {
    return FormCard(
      title: S.of(context).lease_length,
      body: Wrap(
        runSpacing: 16.0,
        children: [
          TermsItemWidget.getTitleBar(context),
          TermsItemWidget(
              termsItemSettings:
                  _listing.settings[TermsItem.earliestStartDate]!,
              child: DatePickerFormField(
                labelText: S.of(context).lease_earliest_start_date,
                helperText: S.of(context).lease_earliest_start_date_helper_text,
                pickerHelpText: S.of(context).lease_earliest_start_date,
                initialDate: _terms.earliestStartDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 180)),
                onChanged: (DateTime dateTime) =>
                    _terms.earliestStartDate = dateTime,
                validator: null,
              )),
          TermsItemWidget(
              termsItemSettings: _listing.settings[TermsItem.latestStartDate]!,
              child: DatePickerFormField(
                labelText: S.of(context).lease_latest_start_date,
                pickerHelpText: S.of(context).lease_latest_start_date,
                initialDate: _terms.latestStartDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 180)),
                onChanged: (DateTime dateTime) =>
                    _terms.latestStartDate = dateTime, //todo should not happen without validation
                validator: (DateTime dateTime) {
                  if (dateTime.isBefore(_terms.earliestStartDate)) {
                    return S.of(context).please_put_in_a_date;
                  } else {
                    return null;
                  }
                },
              )),
          TermsItemWidget(
              termsItemSettings: _listing.settings[TermsItem.leaseLength]!,
              child: TextFormField(
                  initialValue: _terms.leaseLength == null
                      ? ''
                      : _terms.leaseLength.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
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
                  })),
          TermsItemWidget(
              termsItemSettings: _listing.settings[TermsItem.gracePeriod]!,
              child: TextFormField(
                  initialValue:
                      _terms.deposit == -1 ? null : _terms.deposit.toString(),
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
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 180)),
                onChanged: (DateTime dateTime) =>
                    _terms.earliestTerminationDate = dateTime,
                validator: null, //todo validator, eg not before today
              )),
          TermsItemWidget(
              // todo if only the the beginning, that use number of days instead and show from which to which date
              // todo gracePeriod start/end combo
              termsItemSettings:
                  _listing.settings[TermsItem.terminationNotice]!,
              child: TextFormField(
                  initialValue:
                      _terms.deposit == -1 ? null : _terms.deposit.toString(),
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
          ],
        ));
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {});
  }

  bool _validate() => _formKey.currentState!.validate();
}
