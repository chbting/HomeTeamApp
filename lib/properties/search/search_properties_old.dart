import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

import '../../ui/theme.dart';

class SearchPropertiesScreenOld extends StatefulWidget {
  const SearchPropertiesScreenOld({Key? key}) : super(key: key);

  @override
  State<SearchPropertiesScreenOld> createState() =>
      SearchPropertiesScreenOldState();
}

class SearchPropertiesScreenOldState extends State<SearchPropertiesScreenOld> {
  final _searchBarKey = GlobalKey();
  final double _imageSize = 120.0;
  final List<Property> _propertyList = getSampleProperties();
  final List<String> _suggestions = [
    TextHelper.s.hong_kong,
    TextHelper.s.kowloon,
    TextHelper.s.new_territories
  ];

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      key: _searchBarKey,
      margins: const EdgeInsets.all(16.0),
      hint: TextHelper.s.search_properties_hint,
      // todo show query
      title: _getSearchBarTitle(),
      hintStyle: const TextStyle(color: Colors.grey),
      // TODO cursor color, light theme color
      // TODO sliver search searchBar
      //backgroundColor: Colors.white,
      scrollPadding: const EdgeInsets.only(bottom: 56.0),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      debounceDelay: const Duration(milliseconds: 500),
      transition: SlideFadeFloatingSearchBarTransition(),
      // open/close transition
      leadingActions: [
        FloatingSearchBarAction(builder: (searchBarContext, animation) {
          return CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              FloatingSearchBar.of(searchBarContext)?.open();
            },
          );
        }),
        FloatingSearchBarAction(
            showIfOpened: true,
            showIfClosed: false,
            builder: (searchBarContext, animation) {
              final searchAppBar = FloatingSearchAppBar.of(searchBarContext)!;
              return CircularButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  FloatingSearchBar.of(searchBarContext)?.close();
                  setState(() {
                    searchAppBar.clear();
                  });
                },
              );
            }),
      ],
      onQueryChanged: (query) {
        // todo update suggestion order
      },
      onSubmitted: (query) {
        _submitQuery(query);
      },
      actions: [
        FloatingSearchBarAction(
            showIfOpened: true,
            showIfClosed: true,
            builder: (searchBarContext, animation) {
              final searchAppBar = FloatingSearchAppBar.of(searchBarContext)!;

              return ValueListenableBuilder<String>(
                valueListenable: searchAppBar.queryNotifer,
                builder: (valueListenableContext, query, _) {
                  if (query.isNotEmpty) {
                    return CircularButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          searchAppBar.clear();
                        });
                      },
                    );
                  } else {
                    return CircularButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {
                          _speechToText((value) {
                            if (value != null) {
                              setState(() {
                                searchAppBar.query = value;
                              });
                              _submitQuery(value);
                            }
                          });
                        });
                  }
                },
              );
            }),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Material(
            elevation: 4.0,
            child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: _suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                final searchBarState =
                    _searchBarKey.currentState as FloatingSearchBarState;
                final searchBar = searchBarState.barState!;
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(_suggestions[index]),
                  onTap: () {
                    searchBar.query = _suggestions[index];
                    //todo execute search
                  },
                );
              },
            ),
          ),
        );
      },
      body: ListView.builder(
          // All are -4.0 internal padding
          padding: const EdgeInsets.only(
              left: 4.0, right: 4.0, top: 4.0, bottom: 68.0),
          primary: false,
          itemCount: _propertyList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Image(
                              width: _imageSize,
                              height: _imageSize,
                              image: _propertyList[index].coverImage)),
                      Property.getPropertyPreviewTextWidget(
                          context, _imageSize, _propertyList[index]),
                    ],
                  )),
            );
          }),
    );
  }

  Widget? _getSearchBarTitle() {
    if (_searchBarKey.currentState != null) {
      final searchBar = _getFloatingSearchAppBar();
      if (searchBar != null) {
        if (searchBar.query.isNotEmpty) {
          return Text(searchBar.query);
        }
      }
    }
    return null;
  }

  FloatingSearchAppBarState? _getFloatingSearchAppBar() {
    if (_searchBarKey.currentState != null) {
      final searchBarState =
          _searchBarKey.currentState as FloatingSearchBarState;
      return searchBarState.barState;
    }
    return null;
  }

  void _submitQuery(String query) {
    debugPrint('search:$query'); //todo
    _getFloatingSearchAppBar()
        ?.close(); //todo close() clear the query in the textfield out, supposed to show the query
    debugPrint('search:${_getFloatingSearchAppBar()?.query}'); //todo
  }

  void _showSpeechToTextUnavailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(TextHelper.s.msg_voice_search_unavailable)));
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
                TextHelper.s.msg_cannot_recognize_speech);
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
                title: Text(TextHelper.s.voice_search),
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
                    child: Text(TextHelper.s.cancel,
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
                    TextHelper.s.msg_cannot_recognize_speech);
              }
              Navigator.of(dialogKey.currentContext!).pop();
            }
          });
    }
  }
}
