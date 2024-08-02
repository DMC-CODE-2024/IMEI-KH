// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuModel _$MenuModelFromJson(Map<String, dynamic> json) => MenuModel()
  ..title = json['name'] as String?
  ..icon = json['logo'] as String?
  ..childList = (json['featureSubmenus'] as List<dynamic>?)
      ?.map((e) => SubMenuModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$MenuModelToJson(MenuModel instance) => <String, dynamic>{
      'name': instance.title,
      'logo': instance.icon,
      'featureSubmenus': instance.childList,
    };
