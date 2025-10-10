import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String? id;
  final String? name;
  final String streetName;
  final String city;
  final String state;
  final int pinCode;
  final double lattitude;
  final double longitude;
  final int? phoneNumber;
  final Timestamp? timestamp;
  final String? title;
  final int? icon;
  AddressModel({
    this.id,
    this.name,
    required this.streetName,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.lattitude,
    required this.longitude,
    this.phoneNumber,
    this.timestamp,
    this.title,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'streetName': streetName,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'lattitude': lattitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'timestamp': timestamp,
      'title': title,
      'icon': icon,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as String,
      name: map['name'] as String,
      streetName: map['streetName'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      pinCode: map['pinCode'] as int,
      lattitude: map['lattitude'] as double,
      longitude: map['longitude'] as double,
      phoneNumber: map['phoneNumber'] as int,
      timestamp: map['timestamp'] as Timestamp,
      title: map['title'] as String,
      icon: map['icon'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(id: $id, name: $name, streetName: $streetName, city: $city, state: $state, pinCode: $pinCode, lattitude: $lattitude, longitude: $longitude, phoneNumber: $phoneNumber, timestamp: $timestamp, title: $title, icon: $icon)';
  }
}
