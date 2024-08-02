// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubMenuModel _$SubMenuModelFromJson(Map<String, dynamic> json) => SubMenuModel()
  ..title = json['name'] as String?
  ..url = json['link'] as String?
  ..status = json['status'] as int?;

Map<String, dynamic> _$SubMenuModelToJson(SubMenuModel instance) =>
    <String, dynamic>{
      'name': instance.title,
      'link': instance.url,
      'status': instance.status,
    };
