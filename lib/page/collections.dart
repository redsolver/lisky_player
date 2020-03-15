import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lisky_player/model/collection.dart';
import 'package:lisky_player/state.dart';

class CollectionsPage extends StatefulWidget {
  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  void initState() {
    _load();

    state.updateRepos();

    super.initState();
  }

  _load() async {
    collectionsBox = await Hive.openLazyBox('collections');

    collections = collectionsBox.keys.cast<String>().toList();

    setState(() {});
  }

  LazyBox collectionsBox;

  List<String> collections;

  AppState get state => Provider.of<AppState>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return collections == null
        ? LinearProgressIndicator()
        : ValueListenableBuilder(
            valueListenable: Hive.box('repos').listenable(),
            builder: (context, box, child) {
              print('REBUILD');
              return RefreshIndicator(
                onRefresh: () async {
                  await state.updateRepos();
                  return;
                },
                child: Scrollbar(
                  child: ListView.builder(
                    //physics: BouncingScrollPhysics(),
                    itemCount: collections.length +
                        (state.currentTrack == null ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == collections.length)
                        return SizedBox(
                          height: 78,
                        );
                      return FutureBuilder(
                          future: collectionsBox.get(collections[index]),
                          builder: (context, snap) {
                            if (!snap.hasData) return ListTile();

                            Collection coll = snap.data;

                            return ListTile(
                              selected: state.currentTrack?.fromCollectionId ==
                                  coll.id,
                              leading: CachedNetworkImage(
                                imageUrl: '${state.skynetPortal}/${coll.cover}',
                                height: 56,
                                width: 56,
                              ),
                              title: Text(coll.name),
                              subtitle: Text(coll.typeRendered +
                                  ' • ' +
                                  coll.artistsRendered),
                              //trailing: Text('${coll.genres.first}'),
                              /*      trailing: IconButton(
                              icon: Icon(Icons.more_vert), onPressed: () {}), */
                              onTap: () {
                                Provider.of<NavigationState>(context,
                                        listen: false)
                                    .selectedCollection = coll;
                                /*     Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TracksPage(coll))); */
                              },
                            );
                          });
                    },

                    // physics: BouncingScrollPhysics(),
                  ),
                ),
              );
            });
  }
}
