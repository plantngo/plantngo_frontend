// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      usertype: json['usertype'] as String,
      address: json['address'] as String,
      token: json['token'] as String,
      greenPoints: json['greenPoints'] as int?,
      preferences: (json['preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'usertype': instance.usertype,
      'address': instance.address,
      'token': instance.token,
      'greenPoints': instance.greenPoints,
      'preferences': instance.preferences,
    };
