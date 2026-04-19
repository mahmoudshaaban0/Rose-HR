import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';
import 'package:rose_hr/features/stores/domain/repositories/stores_repository_interface.dart';

/// Use case for getting all stores
/// Encapsulates business logic for this specific operation
/// Following Single Responsibility Principle
class GetAllStoresUseCase {
  GetAllStoresUseCase(this._repository);

  final IStoresRepository _repository;

  Future<Result<List<StoreEntity>>> execute() {
    return _repository.getAllStores();
  }
}
