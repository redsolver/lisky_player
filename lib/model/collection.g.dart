// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionAdapter extends TypeAdapter<Collection> {
  @override
  final typeId = 2;

  @override
  Collection read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Collection(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      releaseDate: fields[3] as String,
      artists: (fields[4] as List)?.cast<String>(),
      copyright: fields[5] as String,
      genres: (fields[6] as List)?.cast<String>(),
      cover: fields[7] as String,
      publisher: fields[8] as String,
      language: fields[9] as String,
      tracks: (fields[10] as List)?.cast<Track>(),
      desc: fields[12] as String,
    )..updatedAt = fields[11] as int;
  }

  @override
  void write(BinaryWriter writer, Collection obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.releaseDate)
      ..writeByte(4)
      ..write(obj.artists)
      ..writeByte(5)
      ..write(obj.copyright)
      ..writeByte(6)
      ..write(obj.genres)
      ..writeByte(7)
      ..write(obj.cover)
      ..writeByte(8)
      ..write(obj.publisher)
      ..writeByte(9)
      ..write(obj.language)
      ..writeByte(10)
      ..write(obj.tracks)
      ..writeByte(11)
      ..write(obj.updatedAt)
      ..writeByte(12)
      ..write(obj.desc);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collection _$CollectionFromJson(Map<String, dynamic> json) {
  return Collection(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    releaseDate: json['releaseDate'] as String,
    artists: (json['artists'] as List).map((e) => e as String).toList(),
    copyright: json['copyright'] as String,
    genres: (json['genres'] as List).map((e) => e as String).toList(),
    cover: json['cover'] as String,
    publisher: json['publisher'] as String,
    language: json['language'] as String,
    tracks: (json['tracks'] as List)
        .map((e) => Track.fromJson(e as Map<String, dynamic>))
        .toList(),
    desc: json['desc'] as String,
  )..updatedAt = json['updatedAt'] as int;
}

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'releaseDate': instance.releaseDate,
      'artists': instance.artists,
      'copyright': instance.copyright,
      'genres': instance.genres,
      'cover': instance.cover,
      'publisher': instance.publisher,
      'language': instance.language,
      'tracks': instance.tracks,
      'updatedAt': instance.updatedAt,
      'desc': instance.desc,
    };
