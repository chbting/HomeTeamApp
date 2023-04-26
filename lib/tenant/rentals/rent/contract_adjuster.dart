import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/bid.dart';
import 'package:hometeam_client/data/expense.dart';
import 'package:hometeam_client/shared/theme/theme.dart';
import 'package:hometeam_client/shared/ui/form_card.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker_inherited_data.dart';
import 'package:hometeam_client/utils/format.dart';
import 'package:intl/intl.dart';

class ContractAdjusterScreen extends StatefulWidget {
  const ContractAdjusterScreen({Key? key, required this.controller})
      : super(key: key);

  final ContractAdjusterScreenController controller;

  @override
  State<StatefulWidget> createState() => ContractAdjusterScreenState();
}

class ContractAdjusterScreenState extends State<ContractAdjusterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _tenantFeesColumnCount = 2;
  final _tenantFeesRowHeight = 48.0;

  final _leaseStartRangeInYears = 1;
  final _leaseEndRangeInYears = 10;
  final _now = DateTime.now();

  late Bid _bid;

  late final _leaseStartDefault = DateTime(_now.year, _now.month, _now.day + 1);
  late final _leaseEndDefault = DateTime(
      _leaseStartDefault.year + 1,
      _leaseStartDefault.month,
      _leaseStartDefault.day - 1); // Default lease length is 1 year

  late final _leaseStartFirstDate = _leaseStartDefault;
  late final _leaseStartLastDate = DateTime(
      _leaseStartFirstDate.year + _leaseStartRangeInYears,
      _leaseStartFirstDate.month,
      _leaseStartFirstDate.day - 1);
  late DateTime _leaseEndFirstDate, _leaseEndLastDate;

  late final _startDateController = TextEditingController(
      text: Format.date.format(_leaseStartDefault));
  late final _endDateController = TextEditingController(
      text: Format.date.format(_leaseEndDefault));

  @override
  void initState() {
    widget.controller.validate = _validate;
    widget.controller.reset = _reset;
    super.initState();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bid = ContractBrokerInheritedData.of(context)!.bid;
    _bid.biddingTerms.earliestStartDate ??= _leaseStartDefault;
    _bid.biddingTerms.leaseEndDate ??= _leaseEndDefault;
    _updateLeaseEndRange();

    return ListView(
      primary: false,
      // ListView has 4.0 internal padding
      padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: ContractBrokerScreen.stepTitleBarHeight - 4.0,
          bottom: ContractBrokerScreen.bottomButtonContainerHeight - 4.0),
      children: [
        Card(
          child: ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(Icons.place),
            ),
            title: Text(S.of(context).property_address,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
              '${PropertyHelper.getFromId(_bid.biddingTerms.propertyId).address}',
              style: AppTheme.getCardBodyTextStyle(context),
            ),
            isThreeLine: true, //todo address format
          ),
        ),
        FormCard(
          title: S.of(context).contract,
          body: Form(
              key: _formKey,
              child: Wrap(
                children: [
                  TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      initialValue: '${_bid.biddingTerms.rent}',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: const Icon(Icons.attach_money),
                          labelText: S.of(context).monthly_rent),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).please_put_in_a_valid_amount;
                        } else {
                          _bid.biddingTerms.rent = int.parse(value);
                          return null;
                        }
                      }),
                  Container(height: 16.0),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      initialValue: _bid.biddingTerms.deposit.toString(),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: const Icon(Icons.savings),
                          labelText: S.of(context).deposit),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).please_put_in_a_valid_amount;
                        } else {
                          _bid.biddingTerms.deposit = int.parse(value);
                          return null;
                        }
                      }),
                  Container(height: 8.0),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        S.of(context).lease_period,
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 40.0,
                          height: 76.0, // 60 + 8 x 2 (paddings)
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.calendar_today,
                                  color: AppTheme.getTextFieldIconColor(
                                      context)))),
                      _getLeaseStartDatePicker(),
                      Container(width: 16.0),
                      _getLeaseEndDatePicker(),
                    ],
                  ),
                  Container(height: 8.0),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        S.of(context).tenant_pays_the_following,
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                  GridView.count(
                    crossAxisCount: _tenantFeesColumnCount,
                    childAspectRatio://todo 64.0 is the horizontal padding, pay attention when removing FormCard
                        (MediaQuery.of(context).size.width - 64.0) /
                            _tenantFeesColumnCount /
                            _tenantFeesRowHeight,
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      CheckboxListTile(
                          value: !_bid.biddingTerms.expenses[Expense.water]!,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_water,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.biddingTerms.expenses[Expense.water] =
                                  !value!;
                            });
                          }),
                      CheckboxListTile(
                          value: !_bid.biddingTerms.expenses[Expense.rates]!,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_rates,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.biddingTerms.expenses[Expense.rates] =
                                  !value!;
                            });
                          }),
                      CheckboxListTile(
                          value:
                              !_bid.biddingTerms.expenses[Expense.electricity]!,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_electricity,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.biddingTerms.expenses[Expense.electricity] =
                                  !value!;
                            });
                          }),
                      CheckboxListTile(
                          value:
                              !_bid.biddingTerms.expenses[Expense.management]!,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_management,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.biddingTerms.expenses[Expense.management] =
                                  !value!;
                            });
                          }),
                      CheckboxListTile(
                          value: !_bid.biddingTerms.expenses[Expense.gas]!,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_gas,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.biddingTerms.expenses[Expense.gas] = !value!;
                            });
                          }),
                    ],
                  ),
                  Container(height: 16.0),
                  TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      maxLines: 5,
                      maxLength: 100,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          icon: const Icon(Icons.notes),
                          labelText: S.of(context).notes),
                      onChanged: (value) {
                        _bid.notes = value;
                      },
                      validator: (value) {
                        return null;
                      })
                ],
              )),
        ),
      ],
    );
  }

  Widget _getLeaseStartDatePicker() {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
                controller: _startDateController,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: S.of(context).start_date),
                onTap: () {
                  //todo should override and not able to type
                  showDatePicker(
                          context: context,
                          helpText: S.of(context).start_date,
                          initialDate: _bid.biddingTerms.earliestStartDate ?? DateTime.now(),
                          //todo change to startDate, this is different for the landlord's earliestStartDate
                          firstDate: _leaseStartFirstDate,
                          lastDate: _leaseStartLastDate)
                      .then((value) {
                    if (value != null) {
                      _startDateController.text = Format.date.format(value);
                      _bid.biddingTerms.earliestStartDate = value;
                      // auto update end date
                      _bid.biddingTerms.leaseEndDate =
                          DateTime(value.year + 1, value.month, value.day - 1);
                      _endDateController.text = Format.date
                          .format(_bid.biddingTerms.leaseEndDate!);
                      _updateLeaseEndRange();
                    }
                  });
                },
                validator: (value) {
                  try {
                    Format.date.parse(value!);
                    return null;
                  } on Exception {
                    return S.of(context).invalid_date;
                  }
                })));
  }

  Widget _getLeaseEndDatePicker() {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
                controller: _endDateController,
                enableInteractiveSelection: false,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: S.of(context).end_date),
                onTap: () {
                  showDatePicker(
                          context: context,
                          helpText: S.of(context).end_date,
                          initialDate: _bid.biddingTerms.leaseEndDate!,
                          firstDate: _leaseEndFirstDate,
                          lastDate: _leaseEndLastDate)
                      .then((value) {
                    if (value != null) {
                      _endDateController.text =
                          Format.date.format(value);
                      _bid.biddingTerms.leaseEndDate = value;
                    }
                  });
                },
                validator: (value) {
                  try {
                    var end = Format.date.parse(value!);
                    if (end.isBefore(_bid.biddingTerms.earliestStartDate ?? DateTime.now())) {
                      return S.of(context).invalid_date;
                    } else {
                      return null;
                    }
                  } on Exception {
                    return S.of(context).invalid_date;
                  }
                })));
  }

  bool _validate() => _formKey.currentState!.validate();

  void _updateLeaseEndRange() {
    // _leaseEndFirstDate = DateTime(
    //     _bid.biddingTerms.earliestStartDate.year,
    //     _bid.biddingTerms.earliestStartDate.month,
    //     _bid.biddingTerms.earliestStartDate.day + 1); // 1 day after lease start
    // _leaseEndLastDate = DateTime(
    //     _bid.biddingTerms.earliestStartDate.year + _leaseEndRangeInYears,
    //     _bid.biddingTerms.earliestStartDate.month,
    //     _bid.biddingTerms.earliestStartDate.day - 1);
  }

  void _reset() {
    _formKey.currentState!.reset();
    _startDateController.text =
        Format.date.format(_leaseStartDefault);
    _endDateController.text = Format.date.format(_leaseEndDefault);
    setState(() {
      _bid.biddingTerms.expenses[Expense.water] =
          _bid.originalTerms.expenses[Expense.water]!;
      _bid.biddingTerms.expenses[Expense.electricity] =
          _bid.originalTerms.expenses[Expense.electricity]!;
      _bid.biddingTerms.expenses[Expense.gas] =
          _bid.originalTerms.expenses[Expense.gas]!;
      _bid.biddingTerms.expenses[Expense.rates] =
          _bid.originalTerms.expenses[Expense.rates]!;
      _bid.biddingTerms.expenses[Expense.management] =
          _bid.originalTerms.expenses[Expense.management]!;
    });
  }
}

class ContractAdjusterScreenController {
  late bool Function() validate;
  late void Function() reset;
}
