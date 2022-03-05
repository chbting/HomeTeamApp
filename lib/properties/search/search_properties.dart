import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

import '../../theme.dart';

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
      hint: AppLocalizations.of(context)!.search_properties_hint,
      hintStyle: const TextStyle(color: Colors.grey),
      // TODO cursor color, light theme color
      // TODO sliver search bar
      //backgroundColor: Colors.white,
      scrollPadding: const EdgeInsets.only(bottom: 56.0),
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // todo Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      leadingActions: [
        FloatingSearchBarAction(builder: (context, animation) {
          return CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              FloatingSearchBar.of(context)?.open();
            },
          );
        }),
        FloatingSearchBarAction(
            showIfOpened: true,
            showIfClosed: false,
            builder: (context, animation) {
              return CircularButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  FloatingSearchBar.of(context)?.close();
                },
              );
            }),
      ],
      actions: [
        FloatingSearchBarAction(
            showIfOpened: true,
            showIfClosed: false,
            builder: (searchBarContext, animation) {
              final bar = FloatingSearchAppBar.of(searchBarContext)!;

              return ValueListenableBuilder<String>(
                valueListenable: bar.queryNotifer,
                builder: (valueListenableContext, query, _) {
                  if (query.isEmpty) {
                    return CircularButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        final speech = SpeechToText();
                        speech
                            .initialize(
                                onStatus: (value) {},
                                onError: (error) {
                                  if (error.errorMsg == 'error_no_match' ||
                                      error.errorMsg ==
                                          'error_speech_timeout') {
                                    Navigator.of(context).pop();
                                    _showSnackBarMessage(
                                        AppLocalizations.of(context)!
                                            .msg_cannot_recognize_speech);
                                  }
                                })
                            .then((isAvailable) {
                          if (isAvailable) {
                            String localeId = SharedPreferencesHelper()
                                .getVoiceRecognitionLocaleId();

                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!
                                          .voice_search),
                                      contentPadding: EdgeInsets.zero,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: AvatarGlow(
                                                glowColor: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                endRadius: 72.0,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  radius: 40.0,
                                                  child: const Icon(Icons.mic,
                                                      size: 32.0),
                                                ),
                                              )),
                                          Text(SharedPreferencesHelper
                                              .getVoiceRecognitionLanguage(
                                                  localeId, context))
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .cancel,
                                              style: AppTheme
                                                  .getDialogTextButtonTextStyle(
                                                      context)),
                                          onPressed: () {
                                            if (speech.isListening) {
                                              speech.stop();
                                            }
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ]);
                                }).then((value) {
                              if (speech.isListening) {
                                speech.stop();
                              }
                            });
                            speech.listen(
                                // todo lengthen active time
                                localeId: localeId,
                                // todo make sure the 3 locales always work
                                onResult: (result) {
                                  if (result.confidence > 0.0) {
                                    Navigator.of(context).pop();
                                    bar.query = result.recognizedWords;
                                  }
                                });
                          } else {
                            _showSpeechToTextUnavailableMessage();
                          }
                        });
                      },
                    );
                  } else {
                    return CircularButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        bar.clear();
                      },
                    );
                  }
                },
              );
            }),
      ],
      builder: (context, transition) {
        return Container();
        // return ClipRRect(
        //   borderRadius: BorderRadius.circular(8),
        //   child: Material(
        //     color: Colors.white,
        //     elevation: 4.0,
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: Colors.accents.map((color) {
        //         return Container(height: 112, color: color);
        //       }).toList(),
        //     ),
        //   ),
        // );
      },
    );
    //   CustomScrollView(
    //   slivers: <Widget>[
    //     SliverAppBar(
    //       pinned: false,
    //       snap: false,
    //       floating: true,
    //       expandedHeight: kToolbarHeight,
    //       flexibleSpace: FlexibleSpaceBar(
    //         title: ListTile(
    //           title: Text(AppLocalizations.of(context)!.search_properties_hint),
    //         ),
    //       ),
    //     ),
    //     SliverToBoxAdapter(
    //         child: ListTile(
    //       title: Text(AppLocalizations.of(context)!.latest_additions),
    //     )),
    //     SliverList(
    //       delegate: SliverChildBuilderDelegate(
    //         (BuildContext context, int index) {
    //           return SizedBox(
    //             height: 100.0,
    //             child: Center(
    //               child: Text('$index', textScaleFactor: 4),
    //             ),
    //           );
    //         },
    //         childCount: 20,
    //       ),
    //     ),
    //   ],
    // );
  }

  void _showSpeechToTextUnavailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context)!.msg_voice_search_unavailable)));
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
