import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  // todo keep alive maxin?
  final _actionButtonSplashRadius = 24.0;
  bool isOpen = false;
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(16.0),
        child: ListTile(
            leading: IconButton(
              icon: Icon(isOpen ? Icons.arrow_back : Icons.search),
              // todo animation
              splashRadius: _actionButtonSplashRadius,
              onPressed: () {
                isOpen ? _close() : _open();
              },
            ),
            title: Text(query),
            trailing: IconButton(
              icon: const Icon(Icons.mic),
              splashRadius: _actionButtonSplashRadius,
              onPressed: () {},
            )));
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _open() {
    if (!isOpen) {
      setState(() {});
      isOpen = true;
    }
  }

  void _close() {
    if (isOpen) {
      setState(() {});
      isOpen = false;
    }
  }
}
