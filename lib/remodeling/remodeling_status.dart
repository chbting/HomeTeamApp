import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';

class RemodelingStatusScreen extends StatefulWidget {
  const RemodelingStatusScreen({Key? key}) : super(key: key);

  @override
  State<RemodelingStatusScreen> createState() => RemodelingStatusScreenState();
}

class RemodelingStatusScreenState extends State<RemodelingStatusScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Text(S.of(context).remodeling_status);
  }
}
