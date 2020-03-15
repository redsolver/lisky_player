import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:music_player/music_player.dart';
import 'package:provider/provider.dart';
import 'package:lisky_player/model/track.dart';
import 'package:lisky_player/state.dart';

import '../util.dart';

class TrackDetailPage extends StatefulWidget {
  @override
  _TrackDetailPageState createState() => _TrackDetailPageState();
}

class _TrackDetailPageState extends State<TrackDetailPage>
    with SingleTickerProviderStateMixin {
  Track get currentTrack => Provider.of<AppState>(context).currentTrack;
  set currentTrack(Track track) =>
      Provider.of<AppState>(context).currentTrack = track;

  MusicPlayer get musicPlayer =>
      Provider.of<AppState>(context, listen: false).musicPlayer;

  AppState get state => Provider.of<AppState>(context, listen: false);

  double _barHeight = 0;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        value: state.paused ? 0 : 1);
  }

  AnimationController _animationController;

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Column(
        children: <Widget>[
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 3) {
                Navigator.of(context).pop();
              }
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                Hero(
                  tag: 'cover',
                  child: CachedNetworkImage(
                    imageUrl: '${state.skynetPortal}/${currentTrack.cover}',
                  ),
                ),
              ],
            ),
          ),
          /*     ),
          ), */
          // TODO Auto Size Text
          Expanded(
            child: Column(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /*   Hero(
                              tag: 'track_name',
                              child: */
                            Text(
                              currentTrack.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            /*  ), */
                            Text(
                              currentTrack.artistsRendered,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            // TODO AddDescription
                            /*     if (currentTrack.desc == null) ...[
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                currentTrack.desc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(),
                              ),
                            ], */
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              '© ' + (currentTrack.copyright ?? ''),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IconButton(
                          icon: Icon(Icons.keyboard_arrow_down),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Slider(
                        value: seeking
                            ? seekTmpVal
                            : state.position.clamp(0.0, 1.0),
                        onChanged: (d) {
                          print('onChanged $d');
                          setState(() {
                            seekTmpVal = d;
                          });
                        },
                        onChangeStart: (d) {
                          print('onChangeStart $d');
                          setState(() {
                            seekTmpVal = d;
                            seeking = true;
                          });

                          // musicPlayer.seek(0.01);
                        },
                        onChangeEnd: (d) {
                          print('onChangeEnd $d');
                          /* setState(() {
                        }); */

                          // state.position = d;

                          musicPlayer.seek(d);
                          Future.delayed(Duration(milliseconds: 200))
                              .then((value) {
                            seeking = false;
                          });
                        },
                      ),
                      Text(
                        /*   currentTrack.artistsRendered +
                                            ' • ' + */
                        Util.renderDuration(
                                (seeking ? seekTmpVal : state.position) *
                                    currentTrack.durationMs) +
                            ' / ' +
                            Util.renderDuration(
                              currentTrack.durationMs,
                            ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Mdi.heartOutline),
                        iconSize: 28,
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        iconSize: 32,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _animationController,
                        ),
                        iconSize: 42,
                        onPressed: () {
                          if (state.paused) {
                            musicPlayer.resume();
                            _animationController.forward();
                          } else {
                            musicPlayer.pause();
                            _animationController.reverse();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        iconSize: 32,
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      IconButton(
                        icon: Icon(Mdi.accountCashOutline),
                        iconSize: 28,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool seeking = false;
  double seekTmpVal = 0;
}
