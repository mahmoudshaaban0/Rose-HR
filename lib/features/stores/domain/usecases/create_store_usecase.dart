import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';
import 'package:rose_hr/features/stores/domain/repositories/stores_repository_interface.dart';

/// Use case for creating a new store
/// Can include validation logic before creating
class CreateStoreUseCase {
  CreateStoreUseCase(this._repository);

  final IStoresRepository _repository;

  Future<Result<StoreEntity>> execute(StoreEntity store) {
    // Add business logic/validation here if needed
    // For example: validate email format, phone number format, etc.
    
    return _repository.createStore(store);
  }
}
