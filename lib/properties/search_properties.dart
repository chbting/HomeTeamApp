import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
                  final isEmpty = query.isEmpty;

                  return CircularButton(
                    icon: isEmpty
                        ? const Icon(Icons.mic)
                        : const Icon(Icons.close),
                    onPressed: () {
                      if (isEmpty) {
                        final speech = SpeechToText();
                        debugPrint('initializing');
                        speech
                            .initialize(
                                onStatus: (value) {},
                                onError: (value) {
                                  _showSpeechToTextUnavailableMessage();
                                })
                            .then((isAvailable) {
                          if (isAvailable) {
                            speech.listen(onResult: (result) {
                              query = result.recognizedWords;
                              bar.query;
                            });
                          } else {
                            _showSpeechToTextUnavailableMessage();
                          }
                        });
                      } else {
                        bar.clear();
                      }
                    },
                  );
                },
              );
            }),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
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
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech to text unavailable')));
  }
}
