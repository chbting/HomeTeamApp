import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(S.of(context).dashboard));
  }
}
