import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';

class RadioListDialog {
  static show(
      {required BuildContext context,
      required List<String> values,
      required List<String> labels,
      required String defaultValue,
      required String title,
      required Function(String) onChanged}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                  width: double.minPositive,
                  child: _RadioListView(values, labels, defaultValue,
                      (value) => onChanged(value))),
              actions: <Widget>[
                TextButton(
                  child: Text(S.of(context).cancel),
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
  final Function(String) _onChanged;
  final String _defaultValue;

  const _RadioListView(
      this._valueList, this._titleList, this._defaultValue, this._onChanged,
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
              widget._onChanged(value);
            });
          },
        );
      },
    );
  }
}
