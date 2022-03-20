import 'package:flutter/material.dart';
import 'package:tner_client/utils/text_helper.dart';

import '../ui/theme.dart';

class Property {
  final String? name, address, district;
  final int? id, sqFtGross, sqFtNet, monthlyRent, deposit;
  final ImageProvider coverImage;

  //Tenant paid fees
  final bool water = true;
  final bool electricity = true;
  final bool gas = true;
  final bool rates = true;
  final bool management = true;

  Property(this.id, this.name, this.address, this.district, this.sqFtGross,
      this.sqFtNet, this.monthlyRent, this.deposit, this.coverImage);

  static Widget getPropertyPreviewTextWidget(
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
              Text(property.name!,
                  style: Theme.of(context).textTheme.subtitle1!),
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
}

// todo debug lines
// todo English sample
List<Property> getSampleProperties() {
  return [
    Property(1, "康翠臺", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "柴灣", 720, 630, 18400, 36800,
        const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
    Property(2, "聚賢居", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "上環", 631, 712, 32000, 64000,
        const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
    Property(3, "尚翹峰", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "柴灣", 601, 520, 24000, 48000,
        const AssetImage('assets/demo_images/The_Zenith_240px.jpg')),
    Property(4, "康翠臺2", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "柴灣", 720, 630, 18400, 36800,
        const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
    Property(5, "聚賢居2", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "上環", 631, 712, 32000, 64000,
        const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
    Property(7, "尚翹峰2", "灣仔皇后⼤道東258號 尚翹峰 20樓 F室", "柴灣", 601, 520, 24000, 48000,
        const AssetImage('assets/demo_images/The_Zenith_240px.jpg'))
  ];
}
