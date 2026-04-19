import 'package:json_annotation/json_annotation.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';

part 'store_model.g.dart';

/// Data Transfer Object (DTO) for Store
/// This model is responsible for serialization/deserialization
/// Separating models from entities allows data layer changes without affecting domain
@JsonSerializable()
class StoreModel {
  const StoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.phoneNumber,
    required this.email,
    required this.managerName,
    required this.isActive,
    required this.createdAt,
    this.description,
    this.employeeCount,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => _$StoreModelFromJson(json);

  /// Convert domain entity to data model
  factory StoreModel.fromEntity(StoreEntity entity) {
    return StoreModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      city: entity.city,
      country: entity.country,
      phoneNumber: entity.phoneNumber,
      email: entity.email,
      managerName: entity.managerName,
      isActive: entity.isActive,
      createdAt: entity.createdAt.toIso8601String(),
      description: entity.description,
      employeeCount: entity.employeeCount,
    );
  }

  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'city')
  final String city;

  @JsonKey(name: 'country')
  final String country;

  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'manager_name')
  final String managerName;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'employee_count')
  final int? employeeCount;

  Map<String, dynamic> toJson() => _$StoreModelToJson(this);

  /// Convert data model to domain entity
  StoreEntity toEntity() {
    return StoreEntity(
      id: id,
      name: name,
      address: address,
      city: city,
      country: country,
      phoneNumber: phoneNumber,
      email: email,
      managerName: managerName,
      isActive: isActive,
      createdAt: DateTime.parse(createdAt),
      description: description,
      employeeCount: employeeCount,
    );
  }
}
