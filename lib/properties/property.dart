import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme.dart';

/// Data class for properties

class Property {
  String? name, address, district;
  int? id, sqFtGross, sqFtNet, price;
  ImageProvider coverImage;

  Property(this.id, this.name, this.district, this.sqFtGross, this.sqFtNet,
      this.price, this.coverImage);
}

Widget getPropertyPreviewTextWidget(
    BuildContext context, double leadingImageSize, Property property) {
  return Expanded(
      child: SizedBox(
    height: leadingImageSize,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(property.name!, style: Theme.of(context).textTheme.subtitle1!),
            Text(property.district!,
                style: AppTheme.getListTileBodyTextStyle(context))
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${AppLocalizations.of(context)!.area_net_abr}'
                ': ${property.sqFtNet!}'
                ' ${AppLocalizations.of(context)!.sq_ft_abr}',
                style: AppTheme.getListTileBodyTextStyle(context)),
            Text(
                '${AppLocalizations.of(context)!.area_gross_abr}'
                ': ${property.sqFtGross!}'
                ' ${AppLocalizations.of(context)!.sq_ft_abr}',
                style: AppTheme.getListTileBodyTextStyle(context))
          ],
        ),
      ],
    ),
  ));
}