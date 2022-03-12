import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/utils/text_helper.dart';

class RemodelingContactsWidget extends StatefulWidget {
  const RemodelingContactsWidget({Key? key, required this.data})
      : super(key: key);

  final RemodelingSchedulingData data;

  @override
  State<RemodelingContactsWidget> createState() =>
      RemodelingContactsWidgetState();
}

class RemodelingContactsWidgetState extends State<RemodelingContactsWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      primary: false,
      // Or use margin vertical: 8.0, horizontal: 16.0 with the Card
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      children: [
        Card(
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
                    labelText: TextHelper.appLocalizations.address_line1_label,
                    helperText:
                        TextHelper.appLocalizations.address_line1_helper,
                    icon: const Icon(Icons.location_pin)),
                onChanged: (value) {
                  widget.data.addressLine1 = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            TextHelper.appLocalizations.address_line2_label,
                        helperText:
                            TextHelper.appLocalizations.address_line2_helper),
                    onChanged: (value) {
                      widget.data.addressLine2 = value;
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
                              labelText: TextHelper.appLocalizations.district),
                          onChanged: (value) {
                            widget.data.district = value;
                          }),
                    ),
                    Container(width: 16.0),
                    Expanded(
                      child: DropdownButton<String>(
                        hint: Text(TextHelper.appLocalizations.region),
                        isExpanded: true,
                        value: widget.data.region,
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.data.region = newValue!;
                          });
                        },
                        items: <String>[
                          TextHelper.appLocalizations.hong_kong,
                          TextHelper.appLocalizations.kowloon,
                          TextHelper.appLocalizations.new_territories
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
                    widget.data.phoneNumber = value;
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: TextHelper.appLocalizations.contact_number,
                      helperText:
                          TextHelper.appLocalizations.hong_kong_number_only,
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
                              labelText: TextHelper.appLocalizations.name),
                          onChanged: (value) {
                            widget.data.lastName = value;
                          }),
                    ),
                    Container(width: 16.0),
                    Expanded(
                      child: DropdownButton<String>(
                        hint: Text(TextHelper.appLocalizations.title),
                        isExpanded: true,
                        value: widget.data.prefix,
                        onChanged: (String? newValue) {
                          setState(() {
                            widget.data.prefix = newValue!;
                          });
                        },
                        items: <String>[
                          TextHelper.appLocalizations.mr,
                          TextHelper.appLocalizations.mrs,
                          TextHelper.appLocalizations.miss,
                          TextHelper.appLocalizations.ms
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
