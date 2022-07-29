import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';

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
                  '${S.of(context).area_net_abr}'
                  ': ${property.sqFtNet!}'
                  ' ${S.of(context).sq_ft_abr}',
                  style: AppTheme.getListTileBodyTextStyle(context)),
              Text(
                  '${S.of(context).area_gross_abr}'
                  ': ${property.sqFtGross!}'
                  ' ${S.of(context).sq_ft_abr}',
                  style: AppTheme.getListTileBodyTextStyle(context))
            ],
          ),
        ],
      ),
    ));
  }
}

// todo English sample
List<Property> getSampleProperties() {
  return [
    Property(1, "康翠臺", "康翠臺第5座10樓", "柴灣", 720, 630, 18400, 36800,
        const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
    Property(2, "聚賢居", "聚賢居第1座35樓", "上環", 631, 712, 32000, 64000,
        const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
    Property(3, "尚翹峰", "尚翹峰22樓", "灣仔", 601, 520, 24000, 48000,
        const AssetImage('assets/demo_images/The_Zenith_240px.jpg')),
    Property(4, "容龍居", "容龍居20樓C室", "屯門", 494, 407, 15000, 30000,
        const AssetImage('assets/demo_images/dragon_inn_court_240px.png')),
    Property(5, "嘉湖山莊", "嘉湖山莊 景湖居3座", "天水圍", 906, 783, 32000, 64000,
        const AssetImage('assets/demo_images/kenswood_court_240px.png')),
    //notes: google map inaccuracy for this address
    Property(6, "海逸豪園", "海逸豪園2期 玉庭軒10座", "紅磡", 722, 592, 23000, 46000,
        const AssetImage('assets/demo_images/laguna_verde_240px.png')),
    Property(7, "麗港城", "麗港城9座14樓 ", "藍田", 639, 517, 17500, 35000,
        const AssetImage('assets/demo_images/laguna_city_240px.png')),
    Property(8, "珀麗灣", "珀麗灣1期16座", "馬灣", 1362, 1068, 42000, 84000,
        const AssetImage('assets/demo_images/park_island_240px.png')),
    Property(9, "粉嶺名都", "粉嶺名都富臨閣20樓", "紅磡", 500, 369, 13000, 48000,
        const AssetImage('assets/demo_images/fanling_town_centre_240px.png'))
  ];
}
