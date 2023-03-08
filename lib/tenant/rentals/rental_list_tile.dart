import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/ui/theme.dart';
import 'package:hometeam_client/utils/format.dart';

class RentalListTile extends StatelessWidget {
  const RentalListTile(
      {Key? key,
      required this.property,
      this.imageSize = 120.0,
      this.leading,
      this.trailing,
      this.secondaryTrailing})
      : super(key: key);

  final Property property;
  final double imageSize;
  final Widget? leading;
  final Widget? trailing;
  final Widget? secondaryTrailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    // 1. Leading section
                    leading == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: leading,
                          ),
                    // 2. Image section
                    Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Image(
                            width: imageSize,
                            height: imageSize,
                            image: property.coverImage)),
                    // 3. Info and trailing section
                    Expanded(
                        child: SizedBox(
                      height: imageSize,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.title!,
                                style: Theme.of(context).textTheme.titleMedium!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(property.address.district,
                                  style: AppTheme.getListTileBodyTextStyle(
                                      context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${S.of(context).area_net_abr}'
                                  ': ${property.sqFtNet}'
                                  ' ${S.of(context).sq_ft_abr}',
                                  style: AppTheme.getListTileBodyTextStyle(
                                      context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  '${S.of(context).area_gross_abr}'
                                  ': ${property.sqFtGross}'
                                  ' ${S.of(context).sq_ft_abr}',
                                  style: AppTheme.getListTileBodyTextStyle(
                                      context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)
                            ],
                          ),
                        ],
                      ),
                    )),
                    // 4. trailing buttons and rent
                    SizedBox(
                      height: imageSize,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              trailing ?? Container(),
                              secondaryTrailing ?? Container(),
                            ],
                          ),
                          Text(
                              '${Format.currency.format(property.monthlyRent)}'
                              '/${S.of(context).month}',
                              style: AppTheme.getRentTextStyle(context))
                        ],
                      ),
                    ),
                  ],
                )),
            const Divider(thickness: 1.0, height: 0.0)
          ],
        ));
  }
}

class RentalListTileTrailingButton extends StatelessWidget {
  const RentalListTileTrailingButton(
      {Key? key, required this.text, this.icon, this.onTap})
      : super(key: key);

  final String text;
  final IconData? icon;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Wrap(
            spacing: 4.0,
            children: [
              Text(text, style: AppTheme.getInkWellButtonTextStyle(context)),
              icon == null
                  // A null width let the button to take up the whole row
                  ? Container(width: 0.0)
                  : Icon(icon, color: AppTheme.getTertiaryColor(context)),
            ],
          ),
        ));
  }
}
