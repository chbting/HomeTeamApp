import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/expense.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/terms_item.dart';
import 'package:hometeam_client/utils/format.dart';
import 'package:intl/intl.dart';

class TermsForm extends StatefulWidget {
  const TermsForm({Key? key, required this.controller}) : super(key: key);

  final FormController controller;

  @override
  State<StatefulWidget> createState() => TermsFormState();
}

class TermsFormState extends State<TermsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final _earliestStartDateController = TextEditingController(
      text: DateFormat(Format.date).format(DateTime.now()));
  late final _latestStartDateController = TextEditingController(
      text: DateFormat(Format.date).format(DateTime.now()));
  late final _gracePeriodController = TextEditingController(
      text: DateFormat(Format.date).format(DateTime.now()));

  @override
  void initState() {
    widget.controller.reset = _reset;
    widget.controller.validate = _validate;
    super.initState();
  }

  @override
  void dispose() {
    _earliestStartDateController.dispose();
    _latestStartDateController.dispose();
    super.dispose();
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
                child: TextFormField(
                    controller: _earliestStartDateController,
                    keyboardType: TextInputType.none,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).start_date),
                    onTap: () {
                      showDatePicker(
                              context: context,
                              helpText: S.of(context).lease_earliest_start_date,
                              initialDate: terms.earliestStartDate,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 180)))
                          .then((value) {
                        if (value != null) {
                          _earliestStartDateController.text = DateFormat(
                            Format.date,
                          ).format(value);
                          terms.earliestStartDate = value;
                        }
                      });
                    },
                    validator: (value) {
                      try {
                        DateFormat(Format.date).parse(value!);
                        return null;
                      } on Exception {
                        return S.of(context).invalid_date;
                      }
                    })),
            TermsItemWidget(
                termsItemSettings: listing.settings[TermsItem.latestStartDate]!,
                child: TextFormField(
                    controller: _latestStartDateController,
                    keyboardType: TextInputType.none,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).lease_latest_start_date),
                    onTap: () {
                      showDatePicker(
                              context: context,
                              helpText: S.of(context).lease_latest_start_date,
                              initialDate:
                                  terms.latestStartDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 180)))
                          .then((value) {
                        if (value != null) {
                          _latestStartDateController.text = DateFormat(
                            Format.date,
                          ).format(value);
                          terms.latestStartDate = value;
                        }
                      });
                    },
                    validator: (value) {
                      try {
                        DateFormat(Format.date).parse(value!);
                        return null;
                      } on Exception {
                        return S.of(context).invalid_date;
                      }
                    })),
            TermsItemWidget(
                termsItemSettings:
                    listing.settings[TermsItem.earliestStartDate]!,
                child: TextFormField(
                    controller: _gracePeriodController,
                    keyboardType: TextInputType.none,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).grace_period),
                    onTap: () {
                      showDatePicker(
                              context: context,
                              helpText: S.of(context).grace_period,
                              initialDate:
                                  terms.gracePeriodStart ?? DateTime.now(),
                              //todo
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 180)))
                          .then((value) {
                        if (value != null) {
                          _earliestStartDateController.text = DateFormat(
                            Format.date,
                          ).format(value);
                          terms.gracePeriodStart = value;
                        }
                      });
                    },
                    validator: (value) {
                      try {
                        DateFormat(Format.date).parse(value!);
                        return null;
                      } on Exception {
                        return S.of(context).invalid_date;
                      }
                    })),
            const Divider(thickness: 1.0),
            Text(S.of(context).landlord_expenses),
            TermsItemWidget.getTitleBar(context),
            const TermExpenseItem(
                expense: Expense.structure, termsItem: TermsItem.structure),
          ],
        ));
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {});
  }

  bool _validate() => _formKey.currentState!.validate();
}
