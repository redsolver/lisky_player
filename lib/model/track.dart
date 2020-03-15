import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track.g.dart';

@JsonSerializable(nullable: false)
@HiveType(typeId: 3)
class Track {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String desc;

  @JsonKey(nullable: true)
  @HiveField(3)
  List<String> artists;

  @HiveField(4)
  int durationMs;

  @JsonKey(nullable: true)
  @HiveField(5)
  String cover;
  @HiveField(6)
  int trackNumber;

  String copyright;

  String fromCollectionId;

  String get artistsRendered {
    if (artists == null) return '';
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

  Track(
      {this.name,
      this.desc,
      this.artists,
      this.durationMs,
      this.id,
      this.cover,
      this.trackNumber});

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
  Map<String, dynamic> toJson() => _$TrackToJson(this);
}
