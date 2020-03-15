// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepoAdapter extends TypeAdapter<Repo> {
  @override
  final typeId = 1;

  @override
  Repo read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Repo(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as String,
      updatedAt: fields[3] as int,
      protocol: fields[4] as String,
      collections: (fields[5] as Map)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Repo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.protocol)
      ..writeByte(5)
      ..write(obj.collections);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) {
  return Repo(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    updatedAt: json['updatedAt'] as int,
    protocol: json['protocol'] as String,
    collections: Map<String, int>.from(json['collections'] as Map),
  );
}

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'updatedAt': instance.updatedAt,
      'protocol': instance.protocol,
      'collections': instance.collections,
    };
