import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';
import 'package:rose_hr/features/stores/domain/repositories/stores_repository_interface.dart';

/// Use case for getting a store by ID
class GetStoreByIdUseCase {
  GetStoreByIdUseCase(this._repository);

  final IStoresRepository _repository;

  Future<Result<StoreEntity>> execute(int id) {
    return _repository.getStoreById(id);
  }
}
