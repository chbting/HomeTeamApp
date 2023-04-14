import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/expense.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/shared/date_picker_form_field.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/terms_item.dart';

class TermsForm extends StatefulWidget {
  const TermsForm({Key? key, required this.controller}) : super(key: key);

  final FormController controller;

  @override
  State<StatefulWidget> createState() => TermsFormState();
}

class TermsFormState extends State<TermsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.controller.reset = _reset;
    widget.controller.validate = _validate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Listing listing = ListingInheritedData.of(context)!.listing;
    Terms terms = ListingInheritedData.of(context)!.terms;
    return Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16.0,
          children: [
            TermsItemWidget.getTitleBar(context),
            TermsItemWidget(
                termsItemSettings: listing.settings[TermsItem.rent]!,
                child: TextFormField(
                    initialValue:
                        terms.rent == -1 ? null : terms.rent.toString(),
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
                        terms.rent = int.parse(value);
                        return null;
                      }
                    })),
            TermsItemWidget(
                termsItemSettings: listing.settings[TermsItem.deposit]!,
                child: TextFormField(
                    initialValue:
                        terms.deposit == -1 ? null : terms.deposit.toString(),
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
                        terms.deposit = int.parse(value);
                        return null;
                      }
                    })),
            TermsItemWidget(
                termsItemSettings:
                    listing.settings[TermsItem.earliestStartDate]!,
                child: DatePickerFormField(
                  labelText: S.of(context).lease_earliest_start_date,
                  helpText: S.of(context).lease_earliest_start_date,
                  initialDate: terms.earliestStartDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 180)),
                  onChanged: (DateTime dateTime) =>
                      terms.earliestStartDate = dateTime,
                  validator: null, //todo validator, eg not before today
                )),
            TermsItemWidget(
                termsItemSettings: listing.settings[TermsItem.latestStartDate]!,
                child: DatePickerFormField(
                  labelText: S.of(context).lease_latest_start_date,
                  helpText: S.of(context).lease_latest_start_date,
                  initialDate: terms.latestStartDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 180)),
                  onChanged: (DateTime dateTime) =>
                      terms.latestStartDate = dateTime,
                  validator: null, //todo validator
                )),
            TermsItemWidget(
                // todo if only the the beginning, that use number of days instead and show from which to which date
                // todo gracePeriod start/end combo
                termsItemSettings: listing.settings[TermsItem.gracePeriod]!,
                child: DatePickerFormField(
                  labelText: S.of(context).grace_period,
                  helpText: S.of(context).grace_period,
                  initialDate: terms.gracePeriodStart ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 180)),
                  onChanged: (DateTime dateTime) =>
                      terms.gracePeriodStart = dateTime,
                  validator: null, //todo validator
                )),
            const Divider(thickness: 1.0),
            Text(S.of(context).landlord_expenses),
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
