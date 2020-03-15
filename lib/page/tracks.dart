import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_player/music_player.dart';
import 'package:provider/provider.dart';
import 'package:lisky_player/model/collection.dart';
import 'package:lisky_player/model/track.dart';
import 'package:lisky_player/state.dart';
import 'package:lisky_player/util.dart';
import 'dart:math';

class TracksPage extends StatefulWidget {
  final Collection collection;

  TracksPage(this.collection);

  @override
  _TracksPageState createState() => _TracksPageState();
}

// TODO Markdown/HTML for Descriptions
class _CollectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CollectionHeaderDelegate({
    @required this.collection,
  });
  final Collection collection;
  final double minHeight = 60;
  final double maxHeight = 160;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    AppState state = Provider.of<AppState>(context, listen: false);

/*     double padding = (maxHeight - shrinkOffset) * 0.08; */
    bool doBreak = shrinkOffset > 40;

    double topPadding = (maxHeight - shrinkOffset - 60) * 0.1;
    if (topPadding < 0) topPadding = 0;

    return new /* SizedBox.expand */ Container(
      //padding: const EdgeInsets.all(10),

      color: Theme.of(context).cardColor,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: '${state.skynetPortal}/${collection.cover}',
              fit: BoxFit.cover,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8,
                  //right: 16,
                  top: topPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      collection.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    /*    Wrap(
                      children: <Widget>[ */
                    if (!doBreak) ...[
                      Text(
                        collection.artistsRendered,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        collection.typeRendered +
                            ' • ' +
                            collection.releaseDate,
                      ),
                      Wrap(
                        children: <Widget>[
                          for (String genre in collection.genres)
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 4.0, top: 4, bottom: 4),
                              child: Text(
                                genre,
                              ),
                            ),
                        ],
                      ),
                      Flexible(child: Container()),
                      Text(
                        '© ' + (collection.copyright ?? ''),
                      ),
                      //  Text(collection.publisher.toString()),
                      //Text(collection.releaseDate),
                    ],
                    if (doBreak) ...[
                      Text(
                        collection.artistsRendered +
                            ' • ' +
                            collection.typeRendered +
                            ' • ' +
                            collection.releaseDate,
                      ),
                    ]
                    /*  ],
                    ), */
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_CollectionHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}

class _TracksPageState extends State<TracksPage> {
  Collection get collection => widget.collection;
  /*  List<Track> get tracks => collection.tracks; */
  AppState get state => Provider.of<AppState>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, child) {
      return Scrollbar(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: _CollectionHeaderDelegate(collection: collection),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              for (var t in collection.tracks) _buildTile(t),
              SizedBox(
                height: 78,
              )
            ]))
          ],
        ),
      );
    });
  }

  Widget _buildTile(Track t) {
    bool selected = t.id == state.currentTrack?.id;
    Color accentColor = Theme.of(context).accentColor;
    return ListTile(
      selected: selected,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          selected
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Container(
                    // padding: const EdgeInsets.only(left: 2.0),
                    height: 20,
                    width: 20,
                    child: SpinKitFadingGrid(
                      color: accentColor,
                      size: 20.0,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    t.trackNumber.toString(),
                    style: selected
                        ? TextStyle(
                            color: accentColor,
                          )
                        : null,
                  ),
                ),
        ],
      ),
      title: Text(t.name),
      subtitle: Text(
          t.artists == null ? collection.artistsRendered : t.artistsRendered),
      trailing: Text(
        Util.renderDuration(t.durationMs),
        style: selected
            ? TextStyle(
                color: accentColor,
              )
            : null,
      ),
      onTap: () {
        if (t.cover == null) t.cover = collection.cover;
        if (t.artists == null) t.artists = collection.artists;

        if (t.copyright == null) t.copyright = collection.copyright;

        t.fromCollectionId = collection.id;

        state.musicPlayer.play(MusicItem(
          trackName: t.name,
          albumName: collection.name,
          artistName: t.artistsRendered,
          url: '${state.skynetPortal}/${t.id}',
          coverUrl: '${state.skynetPortal}/${t.cover}',
          duration: Duration(milliseconds: t.durationMs),
          id: t.id,
        ));
        //  setState(() {
        state.currentTrack = t;
      },
    );
  }
}
