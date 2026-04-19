import 'package:rose_hr/features/stores/data/models/single_store_response_model.dart';
import 'package:rose_hr/features/stores/data/models/store_model.dart';
import 'package:rose_hr/features/stores/data/models/stores_response_model.dart';

/// Data source for stores feature
/// In a real app, this would make API calls using ApiConsumer
/// For now, using dummy data for reference
class StoresDataSource {
  StoresDataSource();

  // Dummy data store - simulating database/API
  final List<StoreModel> _dummyStores = [
    const StoreModel(
      id: 1,
      name: 'Downtown Store',
      address: '123 Main Street',
      city: 'New York',
      country: 'USA',
      phoneNumber: '+1-555-0101',
      email: 'downtown@example.com',
      managerName: 'John Smith',
      isActive: true,
      createdAt: '2024-01-15T10:00:00Z',
      description: 'Main flagship store in downtown area',
      employeeCount: 45,
    ),
    const StoreModel(
      id: 2,
      name: 'Westside Mall Store',
      address: '456 Shopping Center Blvd',
      city: 'Los Angeles',
      country: 'USA',
      phoneNumber: '+1-555-0102',
      email: 'westside@example.com',
      managerName: 'Sarah Johnson',
      isActive: true,
      createdAt: '2024-02-20T14:30:00Z',
      description: 'Store located in Westside shopping mall',
      employeeCount: 32,
    ),
    const StoreModel(
      id: 3,
      name: 'Airport Branch',
      address: '789 Terminal Road',
      city: 'Chicago',
      country: 'USA',
      phoneNumber: '+1-555-0103',
      email: 'airport@example.com',
      managerName: 'Michael Brown',
      isActive: true,
      createdAt: '2024-03-10T09:15:00Z',
      description: 'Convenient location at the international airport',
      employeeCount: 28,
    ),
    const StoreModel(
      id: 4,
      name: 'Suburban Plaza',
      address: '321 Oak Avenue',
      city: 'Houston',
      country: 'USA',
      phoneNumber: '+1-555-0104',
      email: 'suburban@example.com',
      managerName: 'Emily Davis',
      isActive: false,
      createdAt: '2024-04-05T11:00:00Z',
      description: 'Temporarily closed for renovation',
      employeeCount: 0,
    ),
    const StoreModel(
      id: 5,
      name: 'Beach Front Store',
      address: '555 Ocean Drive',
      city: 'Miami',
      country: 'USA',
      phoneNumber: '+1-555-0105',
      email: 'beachfront@example.com',
      managerName: 'David Wilson',
      isActive: true,
      createdAt: '2024-05-12T16:45:00Z',
      description: 'Premium beachfront location',
      employeeCount: 38,
    ),
  ];

  int _nextId = 6;

  /// Get all stores
  /// In real implementation: apiConsumer.get(Env.stores)
  Future<StoresResponseModel> getAllStores() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Simulate API response structure
    return StoresResponseModel.fromJson({
      'jsonrpc': '2.0',
      'id': null,
      'result': {
        'success': true,
        'status_code': 200,
        'message': 'Stores retrieved successfully',
        'data': _dummyStores.map((store) => store.toJson()).toList(),
      },
    });
  }

  /// Get store by ID
  /// In real implementation: apiConsumer.get('${Env.stores}/$id')
  Future<SingleStoreResponseModel> getStoreById(int id) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final store = _dummyStores.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Store not found'),
    );

    return SingleStoreResponseModel.fromJson({
      'jsonrpc': '2.0',
      'id': null,
      'result': {
        'success': true,
        'status_code': 200,
        'message': 'Store retrieved successfully',
        'data': store.toJson(),
      },
    });
  }

  /// Create a new store
  /// In real implementation: apiConsumer.post(Env.stores, body: {...})
  Future<SingleStoreResponseModel> createStore(StoreModel store) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 400));

    // Create new store with generated ID
    final newStore = StoreModel(
      id: _nextId++,
      name: store.name,
      address: store.address,
      city: store.city,
      country: store.country,
      phoneNumber: store.phoneNumber,
      email: store.email,
      managerName: store.managerName,
      isActive: store.isActive,
      createdAt: DateTime.now().toIso8601String(),
      description: store.description,
      employeeCount: store.employeeCount,
    );

    _dummyStores.add(newStore);

    return SingleStoreResponseModel.fromJson({
      'jsonrpc': '2.0',
      'id': null,
      'result': {
        'success': true,
        'status_code': 201,
        'message': 'Store created successfully',
        'data': newStore.toJson(),
      },
    });
  }

  /// Update existing store
  /// In real implementation: apiConsumer.put('${Env.stores}/${store.id}', body: {...})
  Future<SingleStoreResponseModel> updateStore(StoreModel store) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final index = _dummyStores.indexWhere((s) => s.id == store.id);
    if (index == -1) {
      throw Exception('Store not found');
    }

    _dummyStores[index] = store;

    return SingleStoreResponseModel.fromJson({
      'jsonrpc': '2.0',
      'id': null,
      'result': {
        'success': true,
        'status_code': 200,
        'message': 'Store updated successfully',
        'data': store.toJson(),
      },
    });
  }

  /// Delete store
  /// In real implementation: apiConsumer.delete('${Env.stores}/$id')
  Future<Map<String, dynamic>> deleteStore(int id) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _dummyStores.removeWhere((s) => s.id == id);

    return {
      'jsonrpc': '2.0',
      'id': null,
      'result': {
        'success': true,
        'status_code': 200,
        'message': 'Store deleted successfully',
      },
    };
  }

  /// Search stores by name or city
  /// In real implementation: apiConsumer.get('${Env.stores}/search?q=$query')
  Future<StoresResponseModel> searchStores(String query) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final lowercaseQuery = query.toLowerCase();
    final filteredStores = _dummyStores.where((store) {
      return store.name.toLowerCase().contains(lowercaseQuery) ||
          store.city.toLowerCase().contains(lowercaseQuery);
    }).toList();

    return StoresResponseModel.fromJson({
      'jsonrpc': '2.0',
      'id': null,
      'result': {
        'success': true,
        'status_code': 200,
        'message': 'Search completed successfully',
        'data': filteredStores.map((store) => store.toJson()).toList(),
      },
    });
  }
}
