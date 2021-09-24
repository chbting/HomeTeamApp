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
                  child: RadioListView(valueList, titleList, defaultValue, (value) {
                    callback(value);
                  })),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        }
    );
  }
}

class RadioListView extends StatefulWidget {
  final List<String> valueList, titleList;
  final Function(String) callback;
  final String defaultValue;

  const RadioListView(
      this.valueList, this.titleList, this.defaultValue, this.callback,
      {Key? key})
      : super(key: key);

  @override
  State<RadioListView> createState() => RadioListViewState();
}

class RadioListViewState extends State<RadioListView> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      shrinkWrap: true,
      primary: false,
      itemCount: widget.valueList.length,
      itemBuilder: (context, index) {
        return RadioListTile(
          title: Text(widget.titleList[index]),
          value: widget.valueList[index],
          groupValue: currentValue,
          onChanged: (String? value) {
            setState(() {
              currentValue = value!;
              Navigator.of(context).pop();
              widget.callback(value);
            });
          },
        );
      },
    );
  }
}