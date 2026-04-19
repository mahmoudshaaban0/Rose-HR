import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';
import 'package:rose_hr/features/stores/domain/repositories/stores_repository_interface.dart';

/// Use case for searching stores
class SearchStoresUseCase {
  SearchStoresUseCase(this._repository);

  final IStoresRepository _repository;

  Future<Result<List<StoreEntity>>> execute(String query) async {
    // Add business logic here if needed
    // For example: trim whitespace, validate minimum query length
    final trimmedQuery = query.trim();
    
    if (trimmedQuery.isEmpty) {
      // Return all stores if query is empty
      return _repository.getAllStores();
    }
    
    return _repository.searchStores(trimmedQuery);
  }
}
