// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuModel _$MenuModelFromJson(Map<String, dynamic> json) => MenuModel()
  ..title = json['title'] as String?
  ..icon = json['icon'] as String?
  ..childList = (json['child'] as List<dynamic>?)
      ?.map((e) => SubMenuModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MenuModelToJson(MenuModel instance) => <String, dynamic>{
      'title': instance.title,
      'icon': instance.icon,
      'child': instance.childList,
    };
