import 'package:lisky_player/model/track.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collection.g.dart';

@JsonSerializable(nullable: false)
@HiveType(typeId: 2)
class Collection {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String type;
  @HiveField(3)
  String releaseDate;
  @HiveField(4)
  List<String> artists;
  @HiveField(5)
  String copyright;
  @HiveField(6)
  List<String> genres;
  @HiveField(7)
  String cover;
  @HiveField(8)
  String publisher;
  @HiveField(9)
  String language;

  @HiveField(10)
  List<Track> tracks;

  @HiveField(11)
  int updatedAt;
  @HiveField(12)
  String desc;

  Collection({
    this.id,
    this.name,
    this.type,
    this.releaseDate,
    this.artists,
    this.copyright,
    this.genres,
    this.cover,
    this.publisher,
    this.language,
    this.tracks,
    this.desc,
  });

  String get artistsRendered {
    if (artists.length == 1) {
      return artists.first;
    } else {
      String str = '';
      var arts = artists.sublist(0, artists.length - 1);
      for (var art in arts) {
        str += '$art, ';
      }
      str = str.substring(0, str.length - 2) + ' & ${artists.last}';
      return str;
    }
  }

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);

  String get typeRendered {
    switch (type) {
      case 'album':
        return 'Album';
      case 'podcast':
        return 'Podcast';
      case 'audiobook':
        return 'Audiobook';

      default:
        return type;
    }
  }

  Map<String, dynamic> toJson() => _$CollectionToJson(this);
}
