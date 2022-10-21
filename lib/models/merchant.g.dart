// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Merchant _$MerchantFromJson(Map<String, dynamic> json) => Merchant(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      company: json['company'] as String?,
      token: json['token'] as String,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => Category.fromJSON(e as Map<String, dynamic>))
          .toList(),
      vouchers: (json['vouchers'] as List<dynamic>?)
          ?.map((e) => Voucher.fromJSON(e as Map<String, dynamic>))
          .toList(),
      logoUrl: json['logoUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longtitude: (json['longtitude'] as num?)?.toDouble(),
      cuisineType: json['cuisineType'] as String?,
      priceRating: json['priceRating'] as int?,
      operatingHours: json['operatingHours'] as String?,
      promotions: (json['promotions'] as List<dynamic>?)
          ?.map((e) => Promotion.fromJSON(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MerchantToJson(Merchant instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'company': instance.company,
      'token': instance.token,
      'categories': instance.categories,
      'vouchers': instance.vouchers,
      'promotions': instance.promotions,
      'logoUrl': instance.logoUrl,
      'bannerUrl': instance.bannerUrl,
      'address': instance.address,
      'description': instance.description,
      'latitude': instance.latitude,
      'longtitude': instance.longtitude,
      'cuisineType': instance.cuisineType,
      'priceRating': instance.priceRating,
      'operatingHours': instance.operatingHours,
    };
