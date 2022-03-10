import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  final _leaseStartRange = 180;
  final _now = DateTime.now();
  late final _leaseStartDefault = DateTime(_now.year, _now.month, _now.day + 1);
  late final _leaseEndDefault = DateTime(
      _leaseStartDefault.year + 1,
      _leaseStartDefault.month,
      _leaseStartDefault.day - 1); // Default lease length is 1 year

  late final _leaseStartFirstDate = _leaseStartDefault;
  late final _leaseStartLastDate = DateTime(_leaseStartFirstDate.year,
      _leaseStartFirstDate.month, _leaseStartFirstDate.day + _leaseStartRange);
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
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
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
                    Container(height: 16.0),
                    Text(
                      TextHelper.appLocalizations.lease_length,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
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
                        Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                    controller: _startDateController,
                                    enableInteractiveSelection: false,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: TextHelper
                                            .appLocalizations.start_date),
                                    onTap: () {
                                      // Stop the keyboard from appearing
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      showDatePicker(
                                              context: context,
                                              helpText: TextHelper
                                                  .appLocalizations.start_date,
                                              initialDate: widget
                                                  .offer.offeredStartDate!,
                                              firstDate: _leaseStartFirstDate,
                                              lastDate: _leaseStartLastDate)
                                          .then((value) {
                                        if (value != null) {
                                          _startDateController.text =
                                              DateFormat(
                                            Format.dateFormat,
                                          ).format(value);
                                          widget.offer.offeredStartDate = value;
                                          // auto update end date
                                          widget.offer.offeredEndDate =
                                              DateTime(value.year + 1,
                                                  value.month, value.day - 1);
                                          _endDateController.text = DateFormat(
                                                  Format.dateFormat)
                                              .format(
                                                  widget.offer.offeredEndDate!);
                                          _updateLeaseEndRange();
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      try {
                                        DateFormat(Format.dateFormat)
                                            .parse(value!);
                                        return null;
                                      } on Exception {
                                        return TextHelper
                                            .appLocalizations.invalid_date;
                                      }
                                    }))),
                        Container(width: 16.0),
                        Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextFormField(
                                    controller: _endDateController,
                                    enableInteractiveSelection: false,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: TextHelper
                                            .appLocalizations.end_date),
                                    onTap: () {
                                      // Stop the keyboard from appearing
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      showDatePicker(
                                              context: context,
                                              helpText: TextHelper
                                                  .appLocalizations.end_date,
                                              initialDate:
                                                  widget.offer.offeredEndDate!,
                                              firstDate: _leaseEndFirstDate,
                                              lastDate: _leaseEndLastDate)
                                          .then((value) {
                                        if (value != null) {
                                          _endDateController.text =
                                              DateFormat(Format.dateFormat)
                                                  .format(value);
                                          widget.offer.offeredEndDate = value;
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      try {
                                        var end = DateFormat(Format.dateFormat)
                                            .parse(value!);
                                        if (widget.offer.offeredStartDate ==
                                            null) {
                                          return null;
                                        }
                                        if (end.isBefore(
                                            widget.offer.offeredStartDate!)) {
                                          return TextHelper
                                              .appLocalizations.invalid_date;
                                        } else {
                                          return null;
                                        }
                                      } on Exception {
                                        return TextHelper
                                            .appLocalizations.invalid_date;
                                      }
                                    }))),
                      ],
                    ),
                    Container(height: 16.0)
                  ],
                )),
          ),
        ),
      ],
    );
  }

  bool validate() => _formKey.currentState!.validate();

  void _updateLeaseEndRange() {
    _leaseEndFirstDate = DateTime(
        widget.offer.offeredStartDate!.year,
        widget.offer.offeredStartDate!.month,
        widget.offer.offeredStartDate!.day + 1); // 1 day after lease start
    _leaseEndLastDate = DateTime(
        widget.offer.offeredStartDate!.year + 2,
        widget.offer.offeredStartDate!.month,
        widget.offer.offeredStartDate!.day - 1); // 2 years after lease start
  }

  void reset() {
    _formKey.currentState!.reset();
    _startDateController.text =
        DateFormat(Format.dateFormat).format(_leaseStartDefault);
    _endDateController.text =
        DateFormat(Format.dateFormat).format(_leaseEndDefault);
  }
}
