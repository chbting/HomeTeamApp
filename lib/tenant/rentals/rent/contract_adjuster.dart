import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/contract_bid.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/ui/theme.dart';
import 'package:hometeam_client/utils/format.dart';
import 'package:intl/intl.dart';

class ContractAdjusterScreen extends StatefulWidget {
  const ContractAdjusterScreen(
      {Key? key, required this.property, required this.bid})
      : super(key: key);

  final Property property;
  final ContractBid bid;

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
    super.initState();
    widget.bid.contract.startDate ??= _leaseStartDefault;
    widget.bid.contract.endDate ??= _leaseEndDefault;
    _updateLeaseEndRange();
  }

  @override
  Widget build(BuildContext context) {
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
              '${widget.property.address}',
              style: AppTheme.getCardBodyTextStyle(context),
            ),
            isThreeLine: true, //todo address format
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Wrap(
                  children: [
                    TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        initialValue: '${widget.property.contract.monthlyRent}',
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
                            widget.bid.contract.monthlyRent = int.parse(value);
                            return null;
                          }
                        }),
                    Container(height: 16.0),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        initialValue:
                            widget.property.contract.deposit.toString(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.savings),
                            labelText: S.of(context).deposit),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).please_put_in_a_valid_amount;
                          } else {
                            widget.bid.contract.deposit = int.parse(value);
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
                            value: widget.bid.contract.waterRequired,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(S.of(context).bill_water,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.bid.contract.waterRequired = value!;
                              });
                            }),
                        CheckboxListTile(
                            value: widget.bid.contract.ratesRequired,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(S.of(context).bill_rates,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.bid.contract.ratesRequired = value!;
                              });
                            }),
                        CheckboxListTile(
                            value: widget.bid.contract.electricityRequired,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(S.of(context).bill_electricity,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.bid.contract.electricityRequired =
                                    value!;
                              });
                            }),
                        CheckboxListTile(
                            value: widget.bid.contract.managementRequired,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(S.of(context).bill_management,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.bid.contract.managementRequired = value!;
                              });
                            }),
                        CheckboxListTile(
                            value: widget.bid.contract.gasRequired,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(S.of(context).bill_gas,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.bid.contract.gasRequired = value!;
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
                          widget.bid.notes = value;
                        },
                        validator: (value) {
                          return null;
                        })
                  ],
                )),
          ),
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
                          initialDate: widget.bid.contract.startDate!,
                          firstDate: _leaseStartFirstDate,
                          lastDate: _leaseStartLastDate)
                      .then((value) {
                    if (value != null) {
                      _startDateController.text = DateFormat(
                        Format.date,
                      ).format(value);
                      widget.bid.contract.startDate = value;
                      // auto update end date
                      widget.bid.contract.endDate =
                          DateTime(value.year + 1, value.month, value.day - 1);
                      _endDateController.text = DateFormat(Format.date)
                          .format(widget.bid.contract.endDate!);
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
                          initialDate: widget.bid.contract.endDate!,
                          firstDate: _leaseEndFirstDate,
                          lastDate: _leaseEndLastDate)
                      .then((value) {
                    if (value != null) {
                      _endDateController.text =
                          DateFormat(Format.date).format(value);
                      widget.bid.contract.endDate = value;
                    }
                  });
                },
                validator: (value) {
                  try {
                    var end = DateFormat(Format.date).parse(value!);
                    if (widget.bid.contract.startDate == null) {
                      return null;
                    }
                    if (end.isBefore(widget.bid.contract.startDate!)) {
                      return S.of(context).invalid_date;
                    } else {
                      return null;
                    }
                  } on Exception {
                    return S.of(context).invalid_date;
                  }
                })));
  }

  bool validate() => _formKey.currentState!.validate();

  void _updateLeaseEndRange() {
    _leaseEndFirstDate = DateTime(
        widget.bid.contract.startDate!.year,
        widget.bid.contract.startDate!.month,
        widget.bid.contract.startDate!.day + 1); // 1 day after lease start
    _leaseEndLastDate = DateTime(
        widget.bid.contract.startDate!.year + _leaseEndRangeInYears,
        widget.bid.contract.startDate!.month,
        widget.bid.contract.startDate!.day - 1);
  }

  void reset() {
    _formKey.currentState!.reset();
    _startDateController.text =
        DateFormat(Format.date).format(_leaseStartDefault);
    _endDateController.text = DateFormat(Format.date).format(_leaseEndDefault);
    setState(() {
      widget.bid.contract.waterRequired =
          widget.property.contract.waterRequired;
      widget.bid.contract.electricityRequired =
          widget.property.contract.electricityRequired;
      widget.bid.contract.gasRequired = widget.property.contract.gasRequired;
      widget.bid.contract.ratesRequired =
          widget.property.contract.ratesRequired;
      widget.bid.contract.managementRequired =
          widget.property.contract.managementRequired;
    });
  }
}
