import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/theme/theme.dart';

class LandlordPropertyListTile extends StatefulWidget {
  const LandlordPropertyListTile({
    Key? key,
    required this.property,
    this.imageSize = 120.0,
    this.leading,
    this.trailing,
    this.secondaryTrailing,
    required this.onTap,
  }) : super(key: key);

  final Property property;
  final double imageSize;
  final Widget? leading;
  final Widget? trailing;
  final Widget? secondaryTrailing;
  final VoidCallback onTap;

  @override
  State<StatefulWidget> createState() => LandlordPropertyListTileState();
}

class LandlordPropertyListTileState extends State<LandlordPropertyListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // 1. widget.leading section
                      widget.leading == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: widget.leading,
                            ),
                      // 2. Image section
                      Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: PropertyHelper.getPreviewImage(
                              widget.property, widget.imageSize)),
                      // 3. Info and trailing section
                      Expanded(
                          child: SizedBox(
                        height: widget.imageSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.property.address.addressLine1,
                                  //todo
                                  style:
                                      Theme.of(context).textTheme.titleMedium!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(widget.property.address.district,
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
                                    ': ${widget.property.netArea}'
                                    ' ${S.of(context).sq_ft_abr}',
                                    style: AppTheme.getListTileBodyTextStyle(
                                        context),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(
                                    '${S.of(context).area_gross_abr}'
                                    ': ${widget.property.grossArea}'
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
                        height: widget.imageSize,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                widget.trailing ?? Container(),
                                widget.secondaryTrailing ?? Container(),
                              ],
                            ),
                            Text('Status', //todo
                                style: AppTheme.getRentTextStyle(context))
                          ],
                        ),
                      ),
                    ],
                  )),
              const Divider(thickness: 1.0, height: 0.0)
            ],
          )),
    );
  }
}
