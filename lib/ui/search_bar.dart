import 'package:flutter/material.dart';
import 'package:tner_client/ui/toggled_icon_button.dart';
import 'package:tner_client/utils/text_helper.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  // todo keep alive maxin?
  final _actionButtonSplashRadius = 24.0;
  bool _isOpen = false;
  String query = '';

  final List<String> _suggestions = [
    TextHelper.appLocalizations.hong_kong,
    TextHelper.appLocalizations.kowloon,
    TextHelper.appLocalizations.new_territories
  ];

  // todo
  // left input gradient
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(16.0),
        child: ListTile(
            // todo higher elevation
            leading: ToggleableIconButton(
                startIcon: Icons.search,
                endIcon: Icons.arrow_back,
                onStartPress: _open,
                onEndPress: _close),
            title: Text(query),
            trailing: IconButton(
              icon: const Icon(Icons.mic),
              splashRadius: _actionButtonSplashRadius,
              onPressed: () {},
            )));
  }

  void _open() {
    if (!_isOpen) {
      setState(() {});
      _isOpen = true;
    }
    debugPrint('open');
  }

  void _close() {
    if (_isOpen) {
      setState(() {});
      _isOpen = false;
    }
    debugPrint('close');
  }
}
