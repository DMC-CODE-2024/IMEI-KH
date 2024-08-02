import 'package:eirs/features/check_imei/drawer_menu/sub_menu_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu_model.g.dart';

@JsonSerializable()
class MenuModel {
  @JsonKey(name: 'name')
  String? title;
  @JsonKey(name: 'logo')
  String? icon;
  @JsonKey(name: 'featureSubmenus')
  List<SubMenuModel>? childList;

  MenuModel();

  factory MenuModel.fromJson(Map<String, dynamic> json) =>
      _$MenuModelFromJson(json);

  Map<String, dynamic> toJson() => _$MenuModelToJson(this);
}
