/// Data class for properties

class Property {
  String? name, address, district;
  int? id, sqFtGross, sqFtNet, price;

  Property(this.id, this.name, this.district, this.sqFtGross, this.sqFtNet,
      this.price);
}

List<Property> MOCK_DATA = [
  Property(1, "康翠臺", "柴灣", 720, 630, 18400),
  Property(2, "聚賢居", "上環", 631, 712, 32000),
  Property(3, "尚翹峰", "柴灣", 601, 520, 24000)
];
