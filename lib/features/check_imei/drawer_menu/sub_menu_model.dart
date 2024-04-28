import 'package:json_annotation/json_annotation.dart';

part 'sub_menu_model.g.dart';

@JsonSerializable()
class SubMenuModel {
  String? title;
  String? url;

  SubMenuModel();

  factory SubMenuModel.fromJson(Map<String, dynamic> json) =>
      _$SubMenuModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubMenuModelToJson(this);
}
