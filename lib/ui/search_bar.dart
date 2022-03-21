import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/ui/toggleable_icon_button.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({this.hintText, Key? key}) : super(key: key);

  final String? hintText;

  @override
  State<StatefulWidget> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final _actionButtonSplashRadius = 20.0;
  final _queryController = TextEditingController();
  final ValueNotifier<bool> _isSearchButtonNotifier = ValueNotifier(true);
  late FocusNode _focusNode;
  bool _isOpen = false;

  final List<String> _suggestions = [
    TextHelper.appLocalizations.hong_kong,
    TextHelper.appLocalizations.kowloon,
    TextHelper.appLocalizations.new_territories
  ];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      _focusNode.hasFocus ? _open() : null;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var suggestionWidget = ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Material(
        elevation: 4.0,
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: _suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: const Icon(Icons.history),
              title: Text(_suggestions[index]),
              onTap: () {
                _setQuery(_suggestions[index]);
                //todo execute search
              },
            );
          },
        ),
      ),
    );

    return Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4.0,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ToggleableIconButton(
                    startIcon: Icons.search,
                    endIcon: Icons.arrow_back,
                    isStartButtonNotifier: _isSearchButtonNotifier,
                    onStartPress: _open,
                    onEndPress: () {
                      FocusScope.of(context).unfocus();
                      _close();
                    }),
                Expanded(
                    child: TextField(
                  decoration:
                      InputDecoration.collapsed(hintText: widget.hintText),
                  focusNode: _focusNode,
                  controller: _queryController,
                  onChanged: (value) {
                    setState(() {
                      debugPrint('onchanged:$value'); //todo
                    });
                  },
                  onSubmitted: (value) => _submit(),
                )),
                IconButton(
                  icon: Icon(
                      _queryController.text.isEmpty ? Icons.mic : Icons.close),
                  splashRadius: _actionButtonSplashRadius,
                  onPressed: () {
                    _queryController.text.isEmpty
                        ? _speechToText((value) {
                            if (value != null) {
                              _setQuery(value);
                              _submit();
                            }
                          })
                        : _setQuery('');
                  },
                )
              ],
            )));
  }

  /// *Use this function to programmatically set the query value
  /// Note: TextField.onChanged() will not be triggered by this function
  void _setQuery(String query) {
    setState(() {
      _queryController.text = query;
    });
  }

  void _submit() {
    _close();
    debugPrint('submitted:${_queryController.text}'); //todo
  }

  void _open() {
    if (!_isOpen) {
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {
        _isOpen = true;
        _isSearchButtonNotifier.value = false;
        // todo show suggestions
      });
    }
  }

  void _close() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
        _isSearchButtonNotifier.value = true;
      });
    }
  }

  void _showSpeechToTextUnavailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(TextHelper.appLocalizations.msg_voice_search_unavailable)));
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _speechToText(Function(String?) onSpeechToTextResult) async {
    final speech = SpeechToText();
    final dialogKey = GlobalKey();

    bool isAvailable = await speech.initialize(
        onStatus: (value) {},
        onError: (error) {
          if (error.errorMsg == 'error_no_match' ||
              error.errorMsg == 'error_speech_timeout') {
            Navigator.of(context).pop();
            _showSnackBarMessage(
                TextHelper.appLocalizations.msg_cannot_recognize_speech);
          }
        });
    if (!isAvailable) {
      _showSpeechToTextUnavailableMessage();
      onSpeechToTextResult(null);
    } else {
      String localeId = SharedPreferencesHelper().getVoiceRecognitionLocaleId();

      // Show the speech to text dialog in the foreground
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                key: dialogKey,
                title: Text(TextHelper.appLocalizations.voice_search),
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AvatarGlow(
                          glowColor: Theme.of(context).colorScheme.secondary,
                          endRadius: 72.0,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            radius: 40.0,
                            child: const Icon(Icons.mic, size: 32.0),
                          ),
                        )),
                    Text(SharedPreferencesHelper.getVoiceRecognitionLanguage(
                        localeId))
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(TextHelper.appLocalizations.cancel,
                        style: AppTheme.getDialogTextButtonTextStyle(context)),
                    onPressed: () {
                      speech.isListening ? speech.stop() : null;
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          }).then((value) {
        // make sure speech to text stops
        speech.isListening ? speech.stop() : null;
      });

      // Listen in the background
      speech.listen(
          // todo lengthen active time
          // todo make sure the 3 locales always work
          localeId: localeId,
          onResult: (result) {
            if (result.finalResult) {
              if (result.confidence > 0.0) {
                onSpeechToTextResult(result.recognizedWords);
              } else {
                onSpeechToTextResult(null);
                _showSnackBarMessage(
                    TextHelper.appLocalizations.msg_cannot_recognize_speech);
              }
              Navigator.of(dialogKey.currentContext!).pop();
            }
          });
    }
  }
}
