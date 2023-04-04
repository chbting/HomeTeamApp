import 'package:flutter/cupertino.dart';
import 'package:hometeam_client/data/property.dart';

class PropertyUploaderInheritedData extends InheritedWidget {
  const PropertyUploaderInheritedData({
    Key? key,
    required this.property,
    required Widget child,
  }) : super(key: key, child: child);

  final Property property;

  static PropertyUploaderInheritedData? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<PropertyUploaderInheritedData>();

  @override
  bool updateShouldNotify(covariant PropertyUploaderInheritedData oldWidget) {
    return false;
  }
}
