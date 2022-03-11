import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/format.dart';
import 'package:tner_client/utils/text_helper.dart';

class ContractAdjusterScreen extends StatefulWidget {
  const ContractAdjusterScreen({Key? key, required this.offer})
      : super(key: key);

  final ContractOffer offer;

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
      text: DateFormat(Format.dateFormat).format(_leaseStartDefault));
  late final _endDateController = TextEditingController(
      text: DateFormat(Format.dateFormat).format(_leaseEndDefault));

  @override
  void initState() {
    super.initState();
    widget.offer.offeredStartDate ??= _leaseStartDefault;
    widget.offer.offeredEndDate ??= _leaseEndDefault;
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
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.place)]),
            title: Text(TextHelper.appLocalizations.property_address,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
              '${widget.offer.property.address}',
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Wrap(
                  children: [
                    TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        initialValue: '${widget.offer.property.monthlyRent}',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.attach_money),
                            labelText:
                                TextHelper.appLocalizations.monthly_rent),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return TextHelper
                                .appLocalizations.please_put_in_a_valid_amount;
                          } else {
                            widget.offer.offeredMonthlyRent = int.parse(value);
                            return null;
                          }
                        }),
                    Container(height: 16.0),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        initialValue: '${widget.offer.property.deposit}',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.savings),
                            labelText: TextHelper.appLocalizations.deposit),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return TextHelper
                                .appLocalizations.please_put_in_a_valid_amount;
                          } else {
                            widget.offer.offeredDeposit = int.parse(value);
                            return null;
                          }
                        }),
                    Container(height: 8.0),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          TextHelper.appLocalizations.lease_length,
                          style: Theme.of(context).textTheme.subtitle1,
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
                                    // copied from input_decorator.dart
                                    // _getIconColor(ThemeData themeData)
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white70
                                        : Colors.black45))),
                        _getLeaseStartDatePicker(),
                        Container(width: 16.0),
                        _getLeaseEndDatePicker(),
                      ],
                    ),
                    Container(height: 8.0),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          TextHelper.appLocalizations.tenant_pays_the_following,
                          style: Theme.of(context).textTheme.subtitle1,
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
                            value: widget.offer.offeredWater,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(TextHelper.appLocalizations.bill_water,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.offer.offeredWater = value!;
                              });
                            }),
                        CheckboxListTile(
                            value: widget.offer.offeredRates,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(TextHelper.appLocalizations.bill_rates,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.offer.offeredRates = value!;
                              });
                            }),
                        CheckboxListTile(
                            value: widget.offer.offeredElectricity,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(
                                TextHelper.appLocalizations.bill_electricity,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.offer.offeredElectricity = value!;
                              });
                            }),
                        CheckboxListTile(
                            value: widget.offer.offeredManagement,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(
                                TextHelper.appLocalizations.bill_management,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.offer.offeredManagement = value!;
                              });
                            }),
                        CheckboxListTile(
                            value: widget.offer.offeredGas,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            title: Text(TextHelper.appLocalizations.bill_gas,
                                style:
                                    AppTheme.getListTileBodyTextStyle(context)),
                            onChanged: (bool? value) {
                              setState(() {
                                widget.offer.offeredGas = value!;
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
                            labelText: TextHelper.appLocalizations.notes),
                        onChanged: (value) {
                          widget.offer.notes = value;
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
                    labelText: TextHelper.appLocalizations.start_date),
                onTap: () {
                  // Stop the keyboard from appearing
                  FocusScope.of(context).requestFocus(FocusNode());
                  showDatePicker(
                          context: context,
                          helpText: TextHelper.appLocalizations.start_date,
                          initialDate: widget.offer.offeredStartDate!,
                          firstDate: _leaseStartFirstDate,
                          lastDate: _leaseStartLastDate)
                      .then((value) {
                    if (value != null) {
                      _startDateController.text = DateFormat(
                        Format.dateFormat,
                      ).format(value);
                      widget.offer.offeredStartDate = value;
                      // auto update end date
                      widget.offer.offeredEndDate =
                          DateTime(value.year + 1, value.month, value.day - 1);
                      _endDateController.text = DateFormat(Format.dateFormat)
                          .format(widget.offer.offeredEndDate!);
                      _updateLeaseEndRange();
                    }
                  });
                },
                validator: (value) {
                  try {
                    DateFormat(Format.dateFormat).parse(value!);
                    return null;
                  } on Exception {
                    return TextHelper.appLocalizations.invalid_date;
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
                    labelText: TextHelper.appLocalizations.end_date),
                onTap: () {
                  // Stop the keyboard from appearing
                  FocusScope.of(context).requestFocus(FocusNode());
                  showDatePicker(
                          context: context,
                          helpText: TextHelper.appLocalizations.end_date,
                          initialDate: widget.offer.offeredEndDate!,
                          firstDate: _leaseEndFirstDate,
                          lastDate: _leaseEndLastDate)
                      .then((value) {
                    if (value != null) {
                      _endDateController.text =
                          DateFormat(Format.dateFormat).format(value);
                      widget.offer.offeredEndDate = value;
                    }
                  });
                },
                validator: (value) {
                  try {
                    var end = DateFormat(Format.dateFormat).parse(value!);
                    if (widget.offer.offeredStartDate == null) {
                      return null;
                    }
                    if (end.isBefore(widget.offer.offeredStartDate!)) {
                      return TextHelper.appLocalizations.invalid_date;
                    } else {
                      return null;
                    }
                  } on Exception {
                    return TextHelper.appLocalizations.invalid_date;
                  }
                })));
  }

  bool validate() => _formKey.currentState!.validate();

  void _updateLeaseEndRange() {
    _leaseEndFirstDate = DateTime(
        widget.offer.offeredStartDate!.year,
        widget.offer.offeredStartDate!.month,
        widget.offer.offeredStartDate!.day + 1); // 1 day after lease start
    _leaseEndLastDate = DateTime(
        widget.offer.offeredStartDate!.year + _leaseEndRangeInYears,
        widget.offer.offeredStartDate!.month,
        widget.offer.offeredStartDate!.day - 1);
  }

  void reset() {
    _formKey.currentState!.reset();
    _startDateController.text =
        DateFormat(Format.dateFormat).format(_leaseStartDefault);
    _endDateController.text =
        DateFormat(Format.dateFormat).format(_leaseEndDefault);
  }
}
