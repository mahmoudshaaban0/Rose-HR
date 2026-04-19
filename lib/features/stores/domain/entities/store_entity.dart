import 'package:equatable/equatable.dart';

/// Domain entity representing a Store
/// This is the core business object, independent of data sources
class StoreEntity extends Equatable {
  const StoreEntity({
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

  final int id;
  final String name;
  final String address;
  final String city;
  final String country;
  final String phoneNumber;
  final String email;
  final String managerName;
  final bool isActive;
  final DateTime createdAt;
  final String? description;
  final int? employeeCount;

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        city,
        country,
        phoneNumber,
        email,
        managerName,
        isActive,
        createdAt,
        description,
        employeeCount,
      ];

  StoreEntity copyWith({
    int? id,
    String? name,
    String? address,
    String? city,
    String? country,
    String? phoneNumber,
    String? email,
    String? managerName,
    bool? isActive,
    DateTime? createdAt,
    String? description,
    int? employeeCount,
  }) {
    return StoreEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      managerName: managerName ?? this.managerName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      employeeCount: employeeCount ?? this.employeeCount,
    );
  }
}
