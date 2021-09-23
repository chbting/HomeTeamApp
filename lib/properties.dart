import 'package:flutter/widgets.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({Key? key}) : super(key: key);

  @override
  State<PropertiesScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<PropertiesScreen> {

  @override
  Widget build(BuildContext context) {
    return const Text("properties");
  }

}