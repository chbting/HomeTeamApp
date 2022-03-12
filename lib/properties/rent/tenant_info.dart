import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';
import 'package:tner_client/utils/text_helper.dart';

class TenantInformationScreen extends StatefulWidget {
  const TenantInformationScreen({Key? key, required this.offer})
      : super(key: key);

  final ContractOffer offer;

  @override
  State<StatefulWidget> createState() => TenantInformationScreenState();
}

class TenantInformationScreenState extends State<TenantInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode(); // todo hasFocus doesn't update until keyboard is closed

  @override
  Widget build(BuildContext context) {
    return ListView(
        primary: false,
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: ContractBrokerScreen.stepTitleBarHeight - 4.0,
            bottom: ContractBrokerScreen.bottomButtonContainerHeight - 4.0),
        children: [
          Card(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Wrap(
                  runSpacing: 16.0,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 40.0,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.person_outline,
                                color: focusNode.hasPrimaryFocus
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).iconTheme.color,
                              )),
                        ),
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              //todo next not working
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText:
                                      TextHelper.appLocalizations.last_name),
                              onChanged: (value) {
                                widget.offer.lastName = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return TextHelper
                                      .appLocalizations.info_required;
                                } else {
                                  return null;
                                }
                              }),
                        ),
                        Container(width: 16.0),
                        Expanded(
                          child: DropdownButton<String>(
                            hint: Text(TextHelper.appLocalizations.title),
                            isExpanded: true,
                            value: widget.offer.prefix,
                            onChanged: (String? newValue) {
                              setState(() {
                                widget.offer.prefix = newValue!;
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
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  TextHelper.appLocalizations.first_name),
                          onChanged: (value) {
                            widget.offer.firstName = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return TextHelper.appLocalizations.info_required;
                            } else {
                              return null;
                            }
                          }),
                    ),
                    // todo highlight the icon when these lines has focus
                    TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.branding_watermark),
                            labelText:
                                TextHelper.appLocalizations.id_card_number),
                        onChanged: (value) {
                          //widget.offer.addressLine2 = value;
                        },// todo format input
                        validator: (value) {
                          //todo id card validator
                          return null;
                        }),
                    TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        maxLength: 8,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          widget.offer.phoneNumber = value;
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                TextHelper.appLocalizations.contact_number,
                            helperText: TextHelper
                                .appLocalizations.hong_kong_number_only,
                            icon: const Icon(Icons.phone))),
                    const Divider(thickness: 1.0),
                    TextField(
                      // todo auto complete with the gov api
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText:
                              TextHelper.appLocalizations.address_line1_label,
                          helperText:
                              TextHelper.appLocalizations.address_line1_helper,
                          icon: const Icon(Icons.location_pin)),
                      onChanged: (value) {
                        widget.offer.addressLine1 = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: TextField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: TextHelper
                                  .appLocalizations.address_line2_label,
                              helperText: TextHelper
                                  .appLocalizations.address_line2_helper),
                          onChanged: (value) {
                            widget.offer.addressLine2 = value;
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
                                        TextHelper.appLocalizations.district),
                                onChanged: (value) {
                                  widget.offer.district = value;
                                }),
                          ),
                          Container(width: 16.0),
                          Expanded(
                            child: DropdownButton<String>(
                              hint: Text(TextHelper.appLocalizations.region),
                              isExpanded: true,
                              value: widget.offer.region,
                              onChanged: (String? newValue) {
                                setState(() {
                                  widget.offer.region = newValue!;
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
                  ],
                )),
          ))
        ]);
  }

  bool validate() => _formKey.currentState!.validate();
}
