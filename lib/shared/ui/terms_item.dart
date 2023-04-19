import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/expense.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';

class TermsItemWidget extends StatefulWidget {
  const TermsItemWidget(
      {super.key, required this.child, required this.termsItemSettings});

  final Widget child;
  final TermsItemSettings termsItemSettings;

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

  static Widget getTitleBarNegotiableOnly(BuildContext context) {
    return Row(children: [
      Expanded(flex: 3, child: Container()),
      Expanded(
          flex: 1,
          child:
          Text(S.of(context).negotiable, textAlign: TextAlign.center))
    ]);
  }
}

class TermsItemWidgetState extends State<TermsItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(flex: 2, child: widget.child),
      Expanded(
        flex: 1,
        child: Checkbox(
            value: widget.termsItemSettings.negotiable,
            onChanged: (bool? value) =>
                setState(() => widget.termsItemSettings.negotiable = value!)),
      ),
      Expanded(
        flex: 1,
        child: Checkbox(
            value: widget.termsItemSettings.showToTenant,
            onChanged: widget.termsItemSettings.showToTenantLocked
                ? null
                : (bool? value) => setState(
                    () => widget.termsItemSettings.showToTenant = value!)),
      )
    ]);
  }
}

class TermExpenseItem extends StatefulWidget {
  const TermExpenseItem(
      {super.key,
      required this.expense,
      required this.termsItem});

  final Expense expense;
  final TermsItem termsItem;

  @override
  State<StatefulWidget> createState() => TermsCheckBoxItemState();
}

class TermsCheckBoxItemState extends State<TermExpenseItem> {
  @override
  Widget build(BuildContext context) {
    Listing listing = ListingInheritedData.of(context)!.listing;
    Terms terms = ListingInheritedData.of(context)!.terms;
    return TermsItemWidget(
      termsItemSettings: listing.settings[widget.termsItem]!,
      child: CheckboxListTile(
          title: Text(ExpenseHelper.getName(context, widget.expense)),
          value: terms.expenses[widget.expense],
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (bool? value) =>
              setState(() => terms.expenses[widget.expense] = value!)),
    );
  }
}
