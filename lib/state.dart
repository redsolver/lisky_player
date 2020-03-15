import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_player/music_player.dart';

import 'package:http/http.dart' as http;
import 'package:lisky_player/model/collection.dart';
import 'package:lisky_player/model/repo.dart';

import 'model/track.dart';

class AppState extends ChangeNotifier {
  Track _currentTrack;
  MusicPlayer musicPlayer = MusicPlayer();

  AppState() {
    musicPlayer.onPosition = (double pos) {
      position = pos;
      notifyListeners();
    };

    musicPlayer.onIsPaused = () {
      paused = true;
    };
    musicPlayer.onIsPlaying = () {
      paused = false;
    };
    musicPlayer.onCompleted = () {
      paused = true;
    };
  }

  Track get currentTrack => _currentTrack;
  set currentTrack(Track track) {
    _currentTrack = track;
    notifyListeners();
  }

  double position = 0.0;

  bool _paused = true;

  bool get paused => _paused;

  set paused(bool state) {
    _paused = state;
    notifyListeners();
  }

  final String datGateway = 'https://gateway.mauve.moe';
  final String skynetPortal = 'https://skydrain.net';

  Future updateRepos() async {
    print('Updating repos...');
    var repos = await Hive.openBox('repos');

    await Hive.openLazyBox('collections');

    if (repos.isEmpty)
      repos.put(
          '1f37026cbc50545fbcbb7aa6ea8619ed432e2ff5d87de2a21c5f18fbf304103d',
          Repo.fromJson(json.decode('''{
    "id": "1f37026cbc50545fbcbb7aa6ea8619ed432e2ff5d87de2a21c5f18fbf304103d",
    "name": "Lisky Main Repo",
    "type": "repo",
    "updatedAt": 1584302812862,
    "protocol": "dat",
    "collections": {
        "9b4f1694cccd9dcc024bb521919bdc3d9e0d891172caebcde61d0cb70640dc12": 1584302766367
    }
}''')));

    for (Repo repo in repos.values) {
      print('Updating Repo "${repo.name}"...');
      try {
        await updateRepo(repo);
      } catch (e, st) {
        print('ERROR while updating repo ${repo.name}: $e $st');
      }
    }
    print('Updated repos!');
  }

  Future updateRepo(Repo current) async {
    var res = await http.get('$datGateway/${current.id}/index.json');

    if (res.statusCode == 200) {
      var repo = Repo.fromJson(json.decode(res.body));

      print(repo.updatedAt);
      print(current.updatedAt);

      if (repo.updatedAt > current.updatedAt) {
        print('Repo "${current.name}" changed!');

        for (String collectionId in repo.collections.keys) {
          if (Hive.lazyBox('collections').containsKey(collectionId)) {
            print('CHECK LOCAL Collection "$collectionId"');
            int updatedAt = repo.collections[collectionId];

            Collection collection =
                await Hive.lazyBox('collections').get(collectionId);
            if (collection.updatedAt < updatedAt) {
              print('UPDATE Collection "$collectionId" already up-to-date.');
              await fetchCollection(collectionId);
            } else {
              print('SKIP Collection "$collectionId" already up-to-date.');
            }
          } else {
            print('NEW Collection "$collectionId"');
            await fetchCollection(collectionId);
          }
        }

        Hive.box('repos').put(repo.id, repo);
      }
    } else {
      throw Exception('Status Code ${res.statusCode}');
    }
  }

  Future fetchCollection(String id) async {
    var res = await http.get('$datGateway/${id}/index.json');

    if (res.statusCode == 200) {
      var collection = Collection.fromJson(json.decode(res.body));
      Hive.lazyBox('collections').put(id, collection);

      print('Fetched collection "${collection.name}"');
    } else {
      throw Exception('Status Code ${res.statusCode}');
    }
  }
}

class NavigationState extends ChangeNotifier {
  Collection _selectedCollection;

  Collection get selectedCollection => _selectedCollection;
  set selectedCollection(Collection coll) {
    _selectedCollection = coll;
    notifyListeners();
  }
}
