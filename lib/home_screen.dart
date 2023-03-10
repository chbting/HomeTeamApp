import 'package:flutter/material.dart';
import 'package:hometeam_client/contracts/contracts.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/landlord/contracts_landlord.dart';
import 'package:hometeam_client/landlord/dashboard_screen.dart';
import 'package:hometeam_client/landlord/properties/properties_screen.dart';
import 'package:hometeam_client/settings/settings.dart';
import 'package:hometeam_client/tenant/rentals/rentals_screen.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _landlordWidgets = <Widget>[
    const DashboardScreen(),
    const PropertiesScreen(),
    const LandlordContractsScreen(),
    const SettingsScreen()
  ];
  final _tenantWidgets = <Widget>[
    const RentalsScreen(),
    const ContractsScreen(),
    const SettingsScreen()
  ];
  int _selectedIndex = 0;
  bool _onSettingPage = false;

  @override
  Widget build(BuildContext context) {
    var isLandlordMode = SharedPreferencesHelper.getLandlordMode();
    List<Widget> widgets, destinations;
    if (isLandlordMode) {
      widgets = _landlordWidgets;
      destinations = <Widget>[
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: S.of(context).dashboard,
        ),
        NavigationDestination(
          icon: const Icon(Icons.apartment_outlined),
          selectedIcon: const Icon(Icons.apartment),
          label: S.of(context).properties,
        ),
        NavigationDestination(
          icon: const Icon(Icons.description_outlined),
          selectedIcon: const Icon(Icons.description),
          label: S.of(context).contracts,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: S.of(context).settings,
        )
      ];
    } else {
      widgets = _tenantWidgets;
      destinations = <Widget>[
        NavigationDestination(
          icon: const Icon(Icons.apartment_outlined),
          selectedIcon: const Icon(Icons.apartment),
          label: S.of(context).rentals,
        ),
        NavigationDestination(
          icon: const Icon(Icons.description_outlined),
          selectedIcon: const Icon(Icons.description),
          label: S.of(context).contracts,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: S.of(context).settings,
        )
      ];
    }

    if (_onSettingPage) {
      _selectedIndex = widgets.length - 1;
    }

    return Scaffold(
      body: widgets[_selectedIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() {
                _selectedIndex = index;
                _onSettingPage = (_selectedIndex == widgets.length - 1);
              }),
          destinations: destinations),
    );
  }
}
