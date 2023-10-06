// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:geocoding/geocoding.dart';

class LocationModel {
  final String LocationUid;
  final String Latitude;
  final String Longitude;
  dynamic createdAt;

  LocationModel({
    required this.LocationUid,
    required this.Latitude,
    required this.Longitude,
    required this.createdAt,
  });

  LocationModel copyWith({
    String? LocationUid,
    String? Latitude,
    String? Longitude,
    dynamic? createdAt,
  }) {
    return LocationModel(
      LocationUid: LocationUid ?? this.LocationUid,
      Latitude: Latitude ?? this.Latitude,
      Longitude: Longitude ?? this.Longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'LocationUid': LocationUid,
      'Latitude': Latitude,
      'Longitude': Longitude,
      'createdAt': createdAt,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      LocationUid: map['LocationUid'] as String,
      Latitude: map['Latitude'] as String,
      Longitude: map['Longitude'] as String,
      createdAt: map['createdAt'] as dynamic,
    );
  }

  @override
  String toString() {
    return 'LocationModel(LocationUid: $LocationUid, Latitude: $Latitude, Longitude: $Longitude, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant LocationModel other) {
    if (identical(this, other)) return true;

    return other.LocationUid == LocationUid &&
        other.Latitude == Latitude &&
        other.Longitude == Longitude &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return LocationUid.hashCode ^
        Latitude.hashCode ^
        Longitude.hashCode ^
        createdAt.hashCode;
  }
}
