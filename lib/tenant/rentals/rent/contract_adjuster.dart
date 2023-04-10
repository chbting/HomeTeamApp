import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/contract_bid.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker_inherited_data.dart';
import 'package:hometeam_client/ui/form_card.dart';
import 'package:hometeam_client/ui/theme/theme.dart';
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

  late ContractBid _bid;

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
      text: DateFormat(Format.date).format(_leaseStartDefault));
  late final _endDateController = TextEditingController(
      text: DateFormat(Format.date).format(_leaseEndDefault));

  @override
  void initState() {
    widget.controller.validate = _validate;
    widget.controller.reset = _reset;
    _bid.contractBid.startDate ??= _leaseStartDefault;
    _bid.contractBid.endDate ??= _leaseEndDefault;
    _updateLeaseEndRange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bid = ContractBrokerInheritedData.of(context)!.bid;

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
              '${PropertyHelper.getFromId(_bid.contractOriginal.propertyId).address}',
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
                      initialValue: '${_bid.contractBid.monthlyRent}',
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
                          _bid.contractBid.monthlyRent = int.parse(value);
                          return null;
                        }
                      }),
                  Container(height: 16.0),
                  TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      initialValue: _bid.contractBid.deposit.toString(),
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
                          _bid.contractBid.deposit = int.parse(value);
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
                    childAspectRatio:
                        (MediaQuery.of(context).size.width - 64.0) /
                            _tenantFeesColumnCount /
                            _tenantFeesRowHeight,
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      CheckboxListTile(
                          value: _bid.contractBid.waterRequired,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_water,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.contractBid.waterRequired = value!;
                            });
                          }),
                      CheckboxListTile(
                          value: _bid.contractBid.ratesRequired,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_rates,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.contractBid.ratesRequired = value!;
                            });
                          }),
                      CheckboxListTile(
                          value: _bid.contractBid.electricityRequired,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_electricity,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.contractBid.electricityRequired = value!;
                            });
                          }),
                      CheckboxListTile(
                          value: _bid.contractBid.managementRequired,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_management,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.contractBid.managementRequired = value!;
                            });
                          }),
                      CheckboxListTile(
                          value: _bid.contractBid.gasRequired,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          title: Text(S.of(context).bill_gas,
                              style:
                                  AppTheme.getListTileBodyTextStyle(context)),
                          onChanged: (bool? value) {
                            setState(() {
                              _bid.contractBid.gasRequired = value!;
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
                  showDatePicker(
                          context: context,
                          helpText: S.of(context).start_date,
                          initialDate: _bid.contractBid.startDate!,
                          firstDate: _leaseStartFirstDate,
                          lastDate: _leaseStartLastDate)
                      .then((value) {
                    if (value != null) {
                      _startDateController.text = DateFormat(
                        Format.date,
                      ).format(value);
                      _bid.contractBid.startDate = value;
                      // auto update end date
                      _bid.contractBid.endDate =
                          DateTime(value.year + 1, value.month, value.day - 1);
                      _endDateController.text = DateFormat(Format.date)
                          .format(_bid.contractBid.endDate!);
                      _updateLeaseEndRange();
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
                          initialDate: _bid.contractBid.endDate!,
                          firstDate: _leaseEndFirstDate,
                          lastDate: _leaseEndLastDate)
                      .then((value) {
                    if (value != null) {
                      _endDateController.text =
                          DateFormat(Format.date).format(value);
                      _bid.contractBid.endDate = value;
                    }
                  });
                },
                validator: (value) {
                  try {
                    var end = DateFormat(Format.date).parse(value!);
                    if (_bid.contractBid.startDate == null) {
                      return null;
                    }
                    if (end.isBefore(_bid.contractBid.startDate!)) {
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
    _leaseEndFirstDate = DateTime(
        _bid.contractBid.startDate!.year,
        _bid.contractBid.startDate!.month,
        _bid.contractBid.startDate!.day + 1); // 1 day after lease start
    _leaseEndLastDate = DateTime(
        _bid.contractBid.startDate!.year + _leaseEndRangeInYears,
        _bid.contractBid.startDate!.month,
        _bid.contractBid.startDate!.day - 1);
  }

  void _reset() {
    _formKey.currentState!.reset();
    _startDateController.text =
        DateFormat(Format.date).format(_leaseStartDefault);
    _endDateController.text = DateFormat(Format.date).format(_leaseEndDefault);
    setState(() {
      _bid.contractBid.waterRequired = _bid.contractOriginal.waterRequired;
      _bid.contractBid.electricityRequired =
          _bid.contractOriginal.electricityRequired;
      _bid.contractBid.gasRequired = _bid.contractOriginal.gasRequired;
      _bid.contractBid.ratesRequired = _bid.contractOriginal.ratesRequired;
      _bid.contractBid.managementRequired =
          _bid.contractOriginal.managementRequired;
    });
  }
}

class ContractAdjusterScreenController {
  late bool Function() validate;
  late void Function() reset;
}
