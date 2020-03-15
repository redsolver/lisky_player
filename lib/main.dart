import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';
import 'package:lisky_player/page/collections.dart';
import 'package:lisky_player/model/repo.dart';
import 'package:lisky_player/model/track.dart';
import 'package:lisky_player/page/repos.dart';
import 'package:lisky_player/state.dart';
import 'package:lisky_player/util.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/collection.dart';
import 'page/track_detail.dart';
import 'page/tracks.dart';

main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(RepoAdapter());
  Hive.registerAdapter(CollectionAdapter());
  Hive.registerAdapter(TrackAdapter());

  runApp(ChangeNotifierProvider(
    create: (_) => AppState(),
    child: ChangeNotifierProvider(
      create: (_) => NavigationState(),
      child: MaterialApp(
        home: Home(),
      ),
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {

    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);

    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    if (selectedCollection == null) {
      return false;
    } else {
      Provider.of<NavigationState>(context, listen: false).selectedCollection =
          null;
      return true;
    }
  }

  List<Track> tracks;

  AppState get state => Provider.of<AppState>(context, listen: false);

  Collection get selectedCollection =>
      Provider.of<NavigationState>(context, listen: false).selectedCollection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lisky Player'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
        leading: Consumer<NavigationState>(builder: (context, navState, child) {
          if (navState.selectedCollection == null) {
            return IconButton(
              icon: Icon(Icons.music_note),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            'Lisky Player 1.0.0',
                          ),
                          content: Text(
                              'The Lisky Player streams music, podcasts and audiobooks directly from the Sia Skynet. Cover Images are also loaded from Skynet. Non-static data is loaded via the decentralized Dat Protocol.'),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  launch(
                                      'https://github.com/redsolver/lisky_player');
                                },
                                child: Text(
                                  'GitHub',
                                )),
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Close',
                                )),
                          ],
                        ));
              },
            );
          } else {
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                navState.selectedCollection = null;
              },
            );
          }
        }),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Mdi.libraryMusic),
                title: Text('Collections'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Mdi.cloudSync),
                title: Text('Repos'),
              ),
            ],
            currentIndex: _currentPage,
            onTap: (i) {
              setState(() {
                _currentPage = i;
                if (_currentPage == 1) {
                  Provider.of<NavigationState>(context, listen: false)
                      .selectedCollection = null;
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Consumer<NavigationState>(builder: (context, navState, child) {
            if (_currentPage == 0) {
              if (navState.selectedCollection == null) {
                return CollectionsPage();
              } else {
                return TracksPage(selectedCollection);
              }
            } else {
              return ReposPage();
            }
          }),
          Consumer<AppState>(
            builder: (context, state, child) {
              if (state.currentTrack == null) return SizedBox();

              var currentTrack = state.currentTrack;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 8,
                  child: Material(
                    color: Theme.of(context).cardColor,
                    // color: Colors.white,
                    child: InkWell(
                      onTap: () {
                     
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TrackDetailPage()));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Hero(
                                tag: 'cover',
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${state.skynetPortal}/${currentTrack.cover}',
                                  height: 56,
                                  width: 56,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                    
                                      Text(
                                        currentTrack.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
/*                                   ), */
                                      Wrap(
                                        children: <Widget>[
                                          Text(currentTrack.artistsRendered +
                                              ' • '),
                                          Text(
                                            /*   currentTrack.artistsRendered +
                                                  ' • ' + */
                                            Util.renderDuration(
                                                    (/* (seeking
                                                          ? seekTmpVal
                                                          : */
                                                            state.position) *
                                                        currentTrack
                                                            .durationMs) +
                                                ' / ' +
                                                Util.renderDuration(
                                                  currentTrack.durationMs,
                                                ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              state.paused
                                  ? IconButton(
                                      icon: Icon(Icons.play_arrow),
                                      onPressed: () {
                                        state.musicPlayer.resume();
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.pause),
                                      onPressed: () {
                                        state.musicPlayer.pause();
                                      },
                                    ),
                            ],
                          ),
                          SizedBox(
                            //height: 6,
                            child: LinearProgressIndicator(
                              value: state.position,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _currentPage = 0;
}
