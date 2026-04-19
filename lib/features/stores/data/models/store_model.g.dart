// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => StoreModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  address: json['address'] as String,
  city: json['city'] as String,
  country: json['country'] as String,
  phoneNumber: json['phone_number'] as String,
  email: json['email'] as String,
  managerName: json['manager_name'] as String,
  isActive: json['is_active'] as bool,
  createdAt: json['created_at'] as String,
  description: json['description'] as String?,
  employeeCount: (json['employee_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'country': instance.country,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'manager_name': instance.managerName,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'description': instance.description,
      'employee_count': instance.employeeCount,
    };
