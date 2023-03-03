import 'package:flutter/material.dart';
import 'package:tner_client/contracts/contracts.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/properties/property_screen.dart';
import 'package:tner_client/settings/settings.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var isLandlordMode = SharedPreferencesHelper.getLandlordMode();
    List<Widget> widgets, destinations;
    if (isLandlordMode) {
      widgets = <Widget>[
        const Center(child: Text('Dashboard')),
        const Center(child: Text('Contract: Landlord View')),
        const SettingsScreen()
      ];
      destinations = <Widget>[
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: S.of(context).dashboard,
        ),
        NavigationDestination(
          icon: const Icon(Icons.description_outlined),
          selectedIcon: const Icon(Icons.description),
          label: S.of(context).agreements,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: S.of(context).settings,
        )
      ];
    } else {
      widgets = <Widget>[
        const PropertyScreen(),
        const ContractsScreen(),
        const SettingsScreen()
      ];
      destinations = <Widget>[
        NavigationDestination(
          icon: const Icon(Icons.apartment_outlined),
          selectedIcon: const Icon(Icons.apartment),
          label: S.of(context).property,
        ),
        NavigationDestination(
          icon: const Icon(Icons.description_outlined),
          selectedIcon: const Icon(Icons.description),
          label: S.of(context).agreements,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: S.of(context).settings,
        )
      ];
    }

    return Scaffold(
      body: widgets[_selectedIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() {
                _selectedIndex = index;
              }),
          destinations: destinations),
    );
  }
}
