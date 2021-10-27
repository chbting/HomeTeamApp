import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemodelingContactsWidget extends StatefulWidget {
  const RemodelingContactsWidget({Key? key}) : super(key: key);

  @override
  State<RemodelingContactsWidget> createState() =>
      RemodelingContactsWidgetState();
}

class RemodelingContactsWidgetState extends State<RemodelingContactsWidget>
    with AutomaticKeepAliveClientMixin {
  String _addressLine1 = '';
  String _addressLine2 = '';
  String _district = '';
  String? _region;
  String _phoneNumber = '';
  String _lastName = '';
  String? _prefix;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      primary: false,
      children: [
        Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                runSpacing: 16.0,
                children: [
                  TextField(
                    // todo auto complete with the gov api
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context)!.address_line1_label,
                        helperText:
                            AppLocalizations.of(context)!.address_line1_helper,
                        icon: const Icon(Icons.location_pin)),
                    onChanged: (value) {
                      _addressLine1 = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: TextField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        // todo doesn't go to district field without scrolling first
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!
                                .address_line2_label,
                            helperText: AppLocalizations.of(context)!
                                .address_line2_helper),
                        onChanged: (value) {
                          _addressLine2 = value;
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.district),
                              onChanged: (value) {
                                _district = value;
                              }),
                        ),
                        Container(width: 16.0),
                        Expanded(
                          child: DropdownButton<String>(
                            hint: Text(AppLocalizations.of(context)!.region),
                            isExpanded: true,
                            value: _region,
                            onChanged: (String? newValue) {
                              setState(() {
                                _region = newValue!;
                              });
                            },
                            items: <String>[
                              AppLocalizations.of(context)!.hong_kong,
                              AppLocalizations.of(context)!.kowloon,
                              AppLocalizations.of(context)!.new_territories
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(thickness: 1.0),
                  TextField(
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      maxLength: 8,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        _phoneNumber = value;
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText:
                              AppLocalizations.of(context)!.contact_number,
                          helperText: AppLocalizations.of(context)!
                              .hong_kong_number_only,
                          icon: const Icon(Icons.phone))),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      AppLocalizations.of(context)!.last_name),
                              onChanged: (value) {
                                _lastName = value;
                              }),
                        ),
                        Container(width: 16.0),
                        Expanded(
                          child: DropdownButton<String>(
                            hint: Text(AppLocalizations.of(context)!.prefix),
                            isExpanded: true,
                            value: _prefix,
                            onChanged: (String? newValue) {
                              setState(() {
                                _prefix = newValue!;
                              });
                            },
                            items: <String>[
                              AppLocalizations.of(context)!.mr,
                              AppLocalizations.of(context)!.mrs,
                              AppLocalizations.of(context)!.miss,
                              AppLocalizations.of(context)!.ms
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
