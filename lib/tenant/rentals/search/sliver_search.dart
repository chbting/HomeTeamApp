import 'package:flutter/material.dart';
import 'package:hometeam_client/shared/ui/toggleable_icon_button.dart';
import 'package:hometeam_client/utils/speech_to_text_helper.dart';

class SliverSearch extends StatefulWidget {
  const SliverSearch(
      {required this.itemBuilderDelegate,
      required this.onQuerySubmitted,
      required this.onRefresh,
      this.hintText,
      this.searchSuggestions,
      Key? key})
      : super(key: key);

  final SliverChildBuilderDelegate itemBuilderDelegate;
  final Function(String) onQuerySubmitted;
  final RefreshCallback onRefresh;
  final String? hintText;
  final List<String>? searchSuggestions;
  static const horizontalMargins = 16.0;
  static const verticalMargins = 8.0;

  @override
  State<StatefulWidget> createState() => SliverSearchState();
}

class SliverSearchState extends State<SliverSearch> {
  final _duration = const Duration(milliseconds: 250);
  final _queryController = TextEditingController();
  late FocusNode _focusNode;
  final ValueNotifier<bool> _isSearchButtonNotifier = ValueNotifier(true);
  final ValueNotifier<bool> _isMicButtonNotifier = ValueNotifier(true);
  bool _isSuggestionsOpen = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Notes: sliverAppBarHeight = iconSize + (icon padding + card padding + vertical margins) * 2
    double sliverAppBarHeight = (Theme.of(context).iconTheme.size ?? 24.0) +
        (8.0 + 4.0 + SliverSearch.verticalMargins) * 2;

    return Stack(children: [
      RefreshIndicator(
        onRefresh: widget.onRefresh,
        edgeOffset: sliverAppBarHeight,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: CustomScrollView(slivers: <Widget>[
          _getSearchBar(sliverAppBarHeight),
          // Query results shows here
          SliverList(
            delegate: widget.itemBuilderDelegate,
          ),
        ]),
      ),
      // Search suggestions
      AnimatedSwitcher(
        duration: _duration,
        child: _isSuggestionsOpen
            ? Stack(
                children: [
                  GestureDetector(
                    onTap: _close,
                    child: Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      margin: EdgeInsets.only(top: sliverAppBarHeight),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(
                        left: SliverSearch.horizontalMargins,
                        right: SliverSearch.horizontalMargins,
                        top: sliverAppBarHeight),
                    color: Theme.of(context).canvasColor,
                    child: widget.searchSuggestions == null
                        ? const SizedBox()
                        : ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: widget.searchSuggestions!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: const Icon(Icons.history),
                                title: Text(widget.searchSuggestions![index]),
                                onTap: () {
                                  _setQuery(widget.searchSuggestions![index]);
                                  _submit();
                                },
                              );
                            },
                          ),
                  )
                ],
              )
            : const SizedBox(),
      )
    ]);
  }

  Widget _getSearchBar(double sliverAppBarHeight) {
    return SliverAppBar(
        toolbarHeight: sliverAppBarHeight,
        floating: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0.0,
        titleSpacing: 0.0,
        flexibleSpace: Stack(
          children: [
            // 1. Gradient for ScrollView
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Theme.of(context).colorScheme.background.withOpacity(0.0),
                    Theme.of(context).colorScheme.background
                  ])),
            ),
            // 2. Search suggestion backdrop (top part)
            AnimatedOpacity(
                duration: _duration,
                opacity: _isSuggestionsOpen ? 1.0 : 0.0,
                child: Visibility(
                  visible: _isSuggestionsOpen,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _close,
                        child: Container(
                          width: double.infinity,
                          height: sliverAppBarHeight,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                )),
            // 3. The actual search bar
            Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: SliverSearch.horizontalMargins,
                    vertical: SliverSearch.verticalMargins),
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
                          decoration: InputDecoration.collapsed(
                              hintText: widget.hintText),
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
                              SpeechToTextHelper.speechToText(context, (value) {
                                if (value != null) {
                                  _setQuery(value);
                                  _submit();
                                } else {
                                  searchHasFocused
                                      ? FocusManager.instance.primaryFocus
                                          ?.unfocus()
                                      : null;
                                }
                              });
                            },
                            onEndPressed: () {
                              _setQuery('');
                            }),
                      ],
                    )))
          ],
        ));
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
    if (!_isSuggestionsOpen) {
      // Close the keyboard
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        _isSuggestionsOpen = true;
        _isSearchButtonNotifier.value = false;
      });
    }
  }

  void _close() {
    if (_isSuggestionsOpen) {
      FocusScope.of(context).unfocus();
      setState(() {
        _isSuggestionsOpen = false;
        _isSearchButtonNotifier.value = true;
      });
    }
  }
}
