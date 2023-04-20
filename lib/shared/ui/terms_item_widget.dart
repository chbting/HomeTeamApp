import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/expense.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/json_model/terms_item.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';

class TermsItemWidget extends StatefulWidget {
  const TermsItemWidget(
      {super.key, required this.child, required this.termsItemSettings});

  final Widget child;
  final TermsItemSettings termsItemSettings;

  @override
  State<StatefulWidget> createState() => TermsItemWidgetState();

  static Widget getTitleBar(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(child: Container()),
      SizedBox(
          width: 48.0,
          child:
              Text(S.of(context).show_to_tenant, textAlign: TextAlign.center)),
      const SizedBox(width: 16.0),
      SizedBox(
          width: 48.0,
          child: Text(S.of(context).negotiable, textAlign: TextAlign.center))
    ]);
  }
}

class TermsItemWidgetState extends State<TermsItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: widget.child),
      const SizedBox(width: 16.0),
      Checkbox(
          value: widget.termsItemSettings.showToTenant,
          onChanged: (bool? value) =>
              setState(() => widget.termsItemSettings.showToTenant = value!)),
      const SizedBox(width: 16.0),
      Checkbox(
          value: widget.termsItemSettings.negotiable,
          onChanged: (bool? value) =>
              setState(() => widget.termsItemSettings.negotiable = value!))
    ]);
  }
}

class TermExpenseItem extends StatefulWidget {
  const TermExpenseItem(
      {super.key, required this.expense, required this.termsItem});

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
