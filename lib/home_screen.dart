import 'package:flutter/material.dart';
import 'package:tner_client/contracts/contracts.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/owner/owner.dart';
import 'package:tner_client/properties/property_screen.dart';
import 'package:tner_client/settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: const <Widget>[
        PropertyScreen(),
        ContractsScreen(),
        OwnerScreen(),
        SettingsScreen()
      ]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.apartment),
            label: S.of(context).property,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.description),
            label: S.of(context).agreements,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.perm_identity),
            label: S.of(context).owner,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: S.of(context).settings,
          )
        ],
      ),
    );
  }
}
