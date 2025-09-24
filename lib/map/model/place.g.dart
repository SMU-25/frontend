// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) => Place(
  id: json['id'] as String,
  placeName: json['place_name'] as String,
  phone: json['phone'] as String?,
  addressName: json['address_name'] as String?,
  roadAddressName: json['road_address_name'] as String?,
  categoryGroupCode: json['category_group_code'] as String?,
  categoryGroupName: json['category_group_name'] as String?,
  categoryName: json['category_name'] as String?,
  placeUrl: json['place_url'] as String?,
  distance: _toInt(json['distance']),
  longitude: _toDouble(json['x']),
  latitude: _toDouble(json['y']),
);

Map<String, dynamic> _$PlaceToJson(Place instance) => <String, dynamic>{
  'id': instance.id,
  'place_name': instance.placeName,
  'phone': instance.phone,
  'address_name': instance.addressName,
  'road_address_name': instance.roadAddressName,
  'category_group_code': instance.categoryGroupCode,
  'category_group_name': instance.categoryGroupName,
  'category_name': instance.categoryName,
  'place_url': instance.placeUrl,
  'distance': instance.distance,
  'x': instance.longitude,
  'y': instance.latitude,
};
