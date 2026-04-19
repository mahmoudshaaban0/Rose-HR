import 'package:equatable/equatable.dart';

/// Base class for all Stores BLoC events
sealed class StoresEvent extends Equatable {
  const StoresEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all stores
class LoadAllStoresEvent extends StoresEvent {
  const LoadAllStoresEvent();
}

/// Event to load a specific store by ID
class LoadStoreByIdEvent extends StoresEvent {
  const LoadStoreByIdEvent(this.storeId);

  final int storeId;

  @override
  List<Object?> get props => [storeId];
}

/// Event to search stores
class SearchStoresEvent extends StoresEvent {
  const SearchStoresEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to create a new store
class CreateStoreEvent extends StoresEvent {
  const CreateStoreEvent({
    required this.name,
    required this.address,
    required this.city,
    required this.country,
    required this.phoneNumber,
    required this.email,
    required this.managerName,
    required this.isActive,
    this.description,
    this.employeeCount,
  });

  final String name;
  final String address;
  final String city;
  final String country;
  final String phoneNumber;
  final String email;
  final String managerName;
  final bool isActive;
  final String? description;
  final int? employeeCount;

  @override
  List<Object?> get props => [
        name,
        address,
        city,
        country,
        phoneNumber,
        email,
        managerName,
        isActive,
        description,
        employeeCount,
      ];
}

/// Event to update an existing store
class UpdateStoreEvent extends StoresEvent {
  const UpdateStoreEvent({
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
}

/// Event to delete a store
class DeleteStoreEvent extends StoresEvent {
  const DeleteStoreEvent(this.storeId);

  final int storeId;

  @override
  List<Object?> get props => [storeId];
}

/// Event to reset the BLoC state
class ResetStoresEvent extends StoresEvent {
  const ResetStoresEvent();
}
