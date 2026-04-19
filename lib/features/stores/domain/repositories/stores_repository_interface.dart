import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';

/// Repository interface (contract) for stores feature
/// This defines what operations are available without specifying implementation
/// Following Dependency Inversion Principle - high-level modules don't depend on low-level modules
abstract class IStoresRepository {
  /// Get all stores
  Future<Result<List<StoreEntity>>> getAllStores();

  /// Get a single store by ID
  Future<Result<StoreEntity>> getStoreById(int id);

  /// Create a new store
  Future<Result<StoreEntity>> createStore(StoreEntity store);

  /// Update an existing store
  Future<Result<StoreEntity>> updateStore(StoreEntity store);

  /// Delete a store by ID
  Future<Result<bool>> deleteStore(int id);

  /// Search stores by name or city
  Future<Result<List<StoreEntity>>> searchStores(String query);
}
