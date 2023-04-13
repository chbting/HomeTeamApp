import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/listing.dart';

class TermsItemWidget extends StatefulWidget {
  const TermsItemWidget(
      {super.key,
      required this.widget,
      required this.termsItemSetting,
      required this.showToTenantEnabled});

  final Widget widget;
  final TermsItemSettings termsItemSetting;
  final bool showToTenantEnabled;

  @override
  State<StatefulWidget> createState() => TermsItemWidgetState();

  static Widget getTitleBar(BuildContext context) {
    return Row(children: [
      Expanded(flex: 2, child: Container()),
      Expanded(
          flex: 1,
          child: Text(S.of(context).negotiable, textAlign: TextAlign.center)),
      Expanded(
          flex: 1,
          child:
              Text(S.of(context).show_to_tenant, textAlign: TextAlign.center))
    ]);
  }
}

class TermsItemWidgetState extends State<TermsItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(flex: 2, child: widget.widget),
      Expanded(
        flex: 1,
        child: Checkbox(
            value: widget.termsItemSetting.negotiable,
            onChanged: (bool? value) =>
                setState(() => widget.termsItemSetting.negotiable = value!)),
      ),
      Expanded(
        flex: 1,
        child: Checkbox(
            value: true,
            onChanged: widget.showToTenantEnabled
                ? (bool? value) => setState(
                    () => widget.termsItemSetting.showToTenant = value!)
                : null),
      )
    ]);
  }
}
