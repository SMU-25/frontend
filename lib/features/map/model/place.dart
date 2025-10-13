import 'package:json_annotation/json_annotation.dart';
part 'place.g.dart';

@JsonSerializable()
class Place {
  final String id;

  @JsonKey(name: 'place_name')
  final String placeName;

  final String? phone;

  @JsonKey(name: 'address_name')
  final String? addressName;

  @JsonKey(name: 'road_address_name')
  final String? roadAddressName;

  @JsonKey(name: 'category_group_code')
  final String? categoryGroupCode;

  @JsonKey(name: 'category_group_name')
  final String? categoryGroupName;

  @JsonKey(name: 'category_name')
  final String? categoryName;

  @JsonKey(name: 'place_url')
  final String? placeUrl;

  @JsonKey(fromJson: _toInt)
  final int? distance;

  @JsonKey(name: 'x', fromJson: _toDouble)
  final double longitude;

  @JsonKey(name: 'y', fromJson: _toDouble)
  final double latitude;

  Place({
    required this.id,
    required this.placeName,
    this.phone,
    this.addressName,
    this.roadAddressName,
    this.categoryGroupCode,
    this.categoryGroupName,
    this.categoryName,
    this.placeUrl,
    this.distance,
    required this.longitude,
    required this.latitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}

int _toInt(Object? v) => int.tryParse(v?.toString() ?? '') ?? 0;
double _toDouble(Object? v) => double.tryParse(v?.toString() ?? '') ?? 0.0;
