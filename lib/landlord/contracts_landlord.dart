import 'package:flutter/material.dart';
import 'package:hometeam_client/test.dart';

class LandlordContractsScreen extends StatelessWidget {
  const LandlordContractsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return const Center(child: Text('contracts'));
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    const MyHomePage(title: 'Image Picker Demo')))));
  }
}
