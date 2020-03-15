// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackAdapter extends TypeAdapter<Track> {
  @override
  final typeId = 3;

  @override
  Track read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Track(
      name: fields[1] as String,
      desc: fields[2] as String,
      artists: (fields[3] as List)?.cast<String>(),
      durationMs: fields[4] as int,
      id: fields[0] as String,
      cover: fields[5] as String,
      trackNumber: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Track obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.artists)
      ..writeByte(4)
      ..write(obj.durationMs)
      ..writeByte(5)
      ..write(obj.cover)
      ..writeByte(6)
      ..write(obj.trackNumber);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) {
  return Track(
    name: json['name'] as String,
    desc: json['desc'] as String,
    artists: (json['artists'] as List)?.map((e) => e as String)?.toList(),
    durationMs: json['durationMs'] as int,
    id: json['id'] as String,
    cover: json['cover'] as String,
    trackNumber: json['trackNumber'] as int,
  )..copyright = json['copyright'] as String;
}

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'artists': instance.artists,
      'durationMs': instance.durationMs,
      'cover': instance.cover,
      'trackNumber': instance.trackNumber,
      'copyright': instance.copyright,
    };
