import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RadioListDialog {
  static show(
      BuildContext context,
      List<String> valueList,
      List<String> titleList,
      String defaultValue,
      String title,
      Function(String) callback) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                  width: double.minPositive,
                  child: _RadioListView(valueList, titleList, defaultValue,
                      (value) {
                    callback(value);
                  })),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }
}

class _RadioListView extends StatefulWidget {
  final List<String> _valueList, _titleList;
  final Function(String) _callback;
  final String _defaultValue;

  const _RadioListView(
      this._valueList, this._titleList, this._defaultValue, this._callback,
      {Key? key})
      : super(key: key);

  @override
  State<_RadioListView> createState() => _RadioListViewState();
}

class _RadioListViewState extends State<_RadioListView> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget._defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10.0),
      shrinkWrap: true,
      primary: false,
      itemCount: widget._valueList.length,
      itemBuilder: (context, index) {
        return RadioListTile(
          title: Text(widget._titleList[index]),
          value: widget._valueList[index],
          groupValue: _currentValue,
          onChanged: (String? value) {
            setState(() {
              _currentValue = value!;
              Navigator.of(context).pop();
              widget._callback(value);
            });
          },
        );
      },
    );
  }
}
