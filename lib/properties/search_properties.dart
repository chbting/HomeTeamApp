import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPropertiesScreen extends StatefulWidget {
  const SearchPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPropertiesScreen> createState() => SearchPropertiesScreenState();
}

class SearchPropertiesScreenState extends State<SearchPropertiesScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: false,
          snap: false,
          floating: true,
          expandedHeight: 15.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('SliverAppBar'),
          ),
        ),
        SliverToBoxAdapter(
            child: ListTile(
          title: Text(AppLocalizations.of(context)!.latest_additions),
        )),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return SizedBox(
                height: 100.0,
                child: Center(
                  child: Text('$index', textScaleFactor: 4),
                ),
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
