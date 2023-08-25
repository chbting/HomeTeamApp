import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/shared/ui/address_form.dart';
import 'package:hometeam_client/theme/theme.dart';

import 'remodeling_inherited_data.dart';
import 'remodeling_order.dart';
import 'remodeling_scheduler.dart';

class RemodelingContactsWidget extends StatefulWidget {
  const RemodelingContactsWidget({Key? key}) : super(key: key);

  @override
  State<RemodelingContactsWidget> createState() =>
      RemodelingContactsWidgetState();
}

class RemodelingContactsWidgetState extends State<RemodelingContactsWidget>
    with AutomaticKeepAliveClientMixin {
  late RemodelingOrder _data;
  final GlobalKey<ContactPersonFormState> _contactPersonFormKey =
      GlobalKey<ContactPersonFormState>();
  final GlobalKey<AddressFormState> _addressFormKey =
      GlobalKey<AddressFormState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _data = RemodelingInheritedData.of(context)!.info;
    return ListView(
      padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: RemodelingScheduler.stepTitleBarHeight - 4.0,
          bottom: RemodelingScheduler.bottomButtonContainerHeight - 4.0),
      primary: false,
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              child: Wrap(
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    S.of(context).contact_person,
                    style: AppTheme.getCardTitleTextStyle(context),
                  )),
              ContactPersonForm(
                  key: _contactPersonFormKey, client: _data.client),
              const Divider(thickness: 1.0),
              Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    S.of(context).remodeling_address,
                    style: AppTheme.getCardTitleTextStyle(context),
                  )),
              AddressForm(key: _addressFormKey, data: _data.client)
            ],
          )),
        ))
      ],
    );
  }

  bool validate() {
    // note: In "return form1.validate() && form2.validate();", the second
    // statement won't execute if the first return false, therefore validate()
    // must be called separately
    bool contactPersonFormValidated =
        _contactPersonFormKey.currentState!.validate();
    bool addressFormValidated = _addressFormKey.currentState!.validate();
    return contactPersonFormValidated && addressFormValidated;
  }
}
