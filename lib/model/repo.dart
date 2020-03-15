import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'repo.g.dart';

@JsonSerializable(nullable: false)
@HiveType(typeId: 1)
class Repo {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String type;

  @HiveField(3)
  int updatedAt;

  @HiveField(4)
  String protocol;

  @HiveField(5)
  Map<String, int> collections;

  Repo(
      {this.id,
      this.name,
      this.type,
      this.updatedAt,
      this.protocol,
      this.collections});

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);
}
