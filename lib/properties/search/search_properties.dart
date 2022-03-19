import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

import '../../ui/theme.dart';

class SearchPropertiesScreen extends StatefulWidget {
  const SearchPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPropertiesScreen> createState() => SearchPropertiesScreenState();
}

class SearchPropertiesScreenState extends State<SearchPropertiesScreen> {
  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      margins: const EdgeInsets.all(16.0),
      hint: TextHelper.appLocalizations.search_properties_hint,
      hintStyle: const TextStyle(color: Colors.grey),
      // TODO cursor color, light theme color
      // TODO sliver search searchBar
      //backgroundColor: Colors.white,
      scrollPadding: const EdgeInsets.only(bottom: 56.0),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      debounceDelay: const Duration(milliseconds: 500),
      transition: CircularFloatingSearchBarTransition(),
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
              return CircularButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  FloatingSearchBar.of(searchBarContext)?.close();
                },
              );
            }),
      ],
      onQueryChanged: (query) {
        // todo Call your model, bloc, controller here.
      },
      actions: [
        FloatingSearchBarAction(
            showIfOpened: true,
            showIfClosed: true,
            builder: (searchBarContext, animation) {
              final searchBar = FloatingSearchAppBar.of(searchBarContext)!;

              return ValueListenableBuilder<String>(
                valueListenable: searchBar.queryNotifer,
                builder: (valueListenableContext, query, _) {
                  if (query.isNotEmpty) {
                    return CircularButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        searchBar.clear();
                      },
                    );
                  } else {
                    return CircularButton(
                        icon: const Icon(Icons.mic),
                        onPressed: () {
                          _speechToText((value) =>
                              value != null ? searchBar.query = value : null);
                        });
                  }
                },
              );
            }),
      ],
      builder: (context, transition) {
        return Container(); //todo
      },
    );
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
