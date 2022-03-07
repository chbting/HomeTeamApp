import 'package:flutter/material.dart';
import 'package:tner_client/utils/text_helper.dart';

import '../theme.dart';

class Property {
  String? name, address, district;
  int? id, sqFtGross, sqFtNet, rent, deposit;
  ImageProvider coverImage;

  Property(this.id, this.name, this.address, this.district, this.sqFtGross,
      this.sqFtNet, this.rent, this.coverImage) {
    deposit = 20000; // todo
  }

  static List<Property> getSampleList() {
    return [
      Property(1, "康翠臺", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "柴灣", 720, 630, 18400,
          const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
      Property(2, "聚賢居", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "上環", 631, 712, 32000,
          const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
      Property(3, "尚翹峰", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "柴灣", 601, 520, 24000,
          const AssetImage('assets/demo_images/The_Zenith_240px.jpg'))
    ];
  }
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
                '${TextHelper.appLocalizations.area_net_abr}'
                ': ${property.sqFtNet!}'
                ' ${TextHelper.appLocalizations.sq_ft_abr}',
                style: AppTheme.getListTileBodyTextStyle(context)),
            Text(
                '${TextHelper.appLocalizations.area_gross_abr}'
                ': ${property.sqFtGross!}'
                ' ${TextHelper.appLocalizations.sq_ft_abr}',
                style: AppTheme.getListTileBodyTextStyle(context))
          ],
        ),
      ],
    ),
  ));
}
