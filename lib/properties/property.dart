import 'package:flutter/material.dart';

/// Data class for properties

class Property {
  String? name, address, district;
  int? id, sqFtGross, sqFtNet, price;
  ImageProvider coverImage;

  Property(this.id, this.name, this.district, this.sqFtGross, this.sqFtNet,
      this.price, this.coverImage);
}

List<Property> dummyData = [
  Property(1, "康翠臺", "柴灣", 720, 630, 18400,
      const AssetImage('assets/demo_images/Greenwood_Terrace_240px.jpg')),
  Property(2, "聚賢居", "上環", 631, 712, 32000,
      const AssetImage('assets/demo_images/CentreStage_240px.jpg')),
  Property(3, "尚翹峰", "柴灣", 601, 520, 24000,
      const AssetImage('assets/demo_images/The_Zenith_240px.jpg'))
];
