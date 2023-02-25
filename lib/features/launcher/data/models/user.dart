/**
 * @Author: Sanakhatun Shaikh
 * @Date: 10/1/2022
 */

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';
// part 'user_response.g.dart';

///
/// Contains User Response from Remote API
///
/// Note:
/// Begins with curly braces? It’s a map.
// Begins with a Square bracket? That’s a List of maps.
///
///

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final String createdAt;

  @JsonKey(name: 'name')
  final String name;

  const User(this.id, this.createdAt, this.name);

  @override
  // TODO: implement props
  List<Object?> get props => [id, createdAt, name];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
