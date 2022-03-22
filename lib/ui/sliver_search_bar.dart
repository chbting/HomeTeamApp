import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/ui/toggleable_icon_button.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

class SliverSearchBar extends StatefulWidget {
  const SliverSearchBar(
      {this.hintText,
      required this.itemBuilderDelegate,
      this.searchSuggestions,
      required this.onQuerySubmitted,
      Key? key})
      : super(key: key);

  final String? hintText;
  final SliverChildBuilderDelegate itemBuilderDelegate;
  final List<String>? searchSuggestions;
  final Function(String) onQuerySubmitted;
  static const horizontalMargins = 16.0;
  static const verticalMargins = 8.0;

  @override
  State<StatefulWidget> createState() => SliverSearchBarState();
}

class SliverSearchBarState extends State<SliverSearchBar> {
  final _duration = const Duration(milliseconds: 250);
  final _queryController = TextEditingController();
  late FocusNode _focusNode;
  final ValueNotifier<bool> _isSearchButtonNotifier = ValueNotifier(true);
  final ValueNotifier<bool> _isMicButtonNotifier = ValueNotifier(true);
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
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Note: toolbarHeight = iconSize + (icon padding + card padding +
    //  vertical margins) * 2
    double sliverAppBarHeight = (Theme.of(context).iconTheme.size ?? 24.0) +
        (8.0 + 4.0 + SliverSearchBar.verticalMargins) * 2;

    return Stack(children: [
      CustomScrollView(slivers: <Widget>[
        SliverAppBar(
            toolbarHeight: sliverAppBarHeight,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            titleSpacing: 0.0,
            flexibleSpace: Stack(
              children: [
                // Gradient for ScrollView
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.0),
                        Theme.of(context).scaffoldBackgroundColor
                      ])),
                ),
                // Search suggestion backdrop (top part)
                AnimatedOpacity(
                    duration: _duration,
                    opacity: _isOpen ? 1.0 : 0.0,
                    child: Visibility(
                      visible: _isOpen,
                      child: Stack(
                        children: [
                          GestureDetector(
                            child: Container(
                              width: double.infinity,
                              height: sliverAppBarHeight,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            onTap: _close,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            title: _buildSearchBar()),
        // Query results shows here
        SliverList(
          delegate: widget.itemBuilderDelegate,
        ),
      ]),
      // Search suggestions
      AnimatedSwitcher(
        duration: _duration,
        child: _isOpen
            ? Stack(
                children: [
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      margin: EdgeInsets.only(top: sliverAppBarHeight),
                    ),
                    onTap: _close,
                  ),
                  Card(
                    margin: EdgeInsets.only(
                        left: SliverSearchBar.horizontalMargins,
                        right: SliverSearchBar.horizontalMargins,
                        top: sliverAppBarHeight),
                    color: Theme.of(context).canvasColor,
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
                            _submit();
                          },
                        );
                      },
                    ),
                  )
                ],
              )
            : Container(),
      )
    ]);
  }

  Widget _buildSearchBar() {
    return Card(
        margin: const EdgeInsets.symmetric(
            horizontal: SliverSearchBar.horizontalMargins,
            vertical: SliverSearchBar.verticalMargins),
        elevation: 4.0,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ToggleableIconButton(
                    startIcon: Icons.search,
                    endIcon: Icons.arrow_back,
                    isStartButtonNotifier: _isSearchButtonNotifier,
                    onStartPressed: _open,
                    onEndPressed: _close),
                Expanded(
                    child: TextField(
                  decoration:
                      InputDecoration.collapsed(hintText: widget.hintText),
                  textInputAction: TextInputAction.search,
                  controller: _queryController,
                  focusNode: _focusNode,
                  onTap: _open,
                  onChanged: (value) {
                    setState(() {
                      _isMicButtonNotifier.value =
                          _queryController.text.isEmpty;
                      //todo update suggestions
                      debugPrint('onChanged:$value');
                    });
                  },
                  onSubmitted: (value) => _submit(),
                )),
                ToggleableIconButton(
                    startIcon: Icons.mic,
                    endIcon: Icons.close,
                    toggleOnPressed: false,
                    isStartButtonNotifier: _isMicButtonNotifier,
                    onStartPressed: () {
                      bool searchHasFocused = _focusNode.hasFocus;
                      FocusScope.of(context).unfocus();
                      _speechToText((value) {
                        if (value != null) {
                          _setQuery(value);
                          _submit();
                        } else {
                          searchHasFocused
                              ? FocusScope.of(context).requestFocus(_focusNode)
                              : null;
                        }
                      });
                    },
                    onEndPressed: () {
                      _setQuery('');
                    }),
              ],
            )));
  }

  /// *Use this function to programmatically set the query value
  /// Note: TextField.onChanged() will not be triggered by this function
  void _setQuery(String query) {
    setState(() {
      _queryController.text = query;
      _isMicButtonNotifier.value = _queryController.text.isEmpty;
      _queryController.selection = TextSelection.fromPosition(
          TextPosition(offset: _queryController.text.length));
    });
  }

  void _submit() {
    _close();
    widget.onQuerySubmitted(_queryController.text);
  }

  void _open() {
    if (!_isOpen) {
      FocusScope.of(context).requestFocus(_focusNode);
      setState(() {
        _isOpen = true;
        _isSearchButtonNotifier.value = false;
      });
    }
  }

  void _close() {
    if (_isOpen) {
      FocusScope.of(context).unfocus();
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
              Navigator.of(dialogKey.currentContext!).pop();
              if (result.confidence > 0.0) {
                onSpeechToTextResult(result.recognizedWords);
              } else {
                onSpeechToTextResult(null);
                _showSnackBarMessage(
                    TextHelper.appLocalizations.msg_cannot_recognize_speech);
              }
            }
          });
    }
  }
}
