import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/ui/toggleable_icon_button.dart';
import 'package:tner_client/utils/speech_to_text_helper.dart';

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

    // todo sample suggestions
    final List<String> sampleSuggestions = [
      S.of(context).hong_kong,
      S.of(context).kowloon,
      S.of(context).new_territories
    ];

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
                            onTap: _close,
                            child: Container(
                              width: double.infinity,
                              height: sliverAppBarHeight,
                              color: Colors.black.withOpacity(0.5),
                            ),
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
                    onTap: _close,
                    child: Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      margin: EdgeInsets.only(top: sliverAppBarHeight),
                    ),
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
                      itemCount: sampleSuggestions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(sampleSuggestions[index]),
                          onTap: () {
                            _setQuery(sampleSuggestions[index]);
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
                      SpeechToTextHelper.speechToText(context, (value) {
                        if (value != null) {
                          _setQuery(value);
                          _submit();
                        } else {
                          searchHasFocused
                              ? // Close the keyboard
                              FocusManager.instance.primaryFocus?.unfocus()
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
      // Close the keyboard
      FocusManager.instance.primaryFocus?.unfocus();
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
}
