import 'package:rose_hr/common/error/exceptions.dart';
import 'package:rose_hr/common/error/failures.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/stores/data/datasources/stores_datasource.dart';
import 'package:rose_hr/features/stores/data/models/store_model.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';
import 'package:rose_hr/features/stores/domain/repositories/stores_repository_interface.dart';

/// Repository implementation for stores feature
/// This is the concrete implementation of IStoresRepository
/// Handles data operations and error mapping
/// Following Repository Pattern - abstracts data source from business logic
class StoresRepository implements IStoresRepository {
  StoresRepository(this.storesDataSource);

  final StoresDataSource storesDataSource;

  @override
  Future<Result<List<StoreEntity>>> getAllStores() async {
    try {
      final response = await storesDataSource.getAllStores();
      
      if (response.result?.success ?? false) {
        final stores = response.result?.data?.map((model) => model.toEntity()).toList() ?? [];
        return Success(stores);
      } else {
        return Error(ServerFailure(response.result?.message ?? 'Something went wrong'));
      }
    } on NoInternetConnectionException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on BadCertificateException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.toString()));
    } on FormatException catch (e) {
      return Error(DataFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<StoreEntity>> getStoreById(int id) async {
    try {
      final response = await storesDataSource.getStoreById(id);
      
      if (response.result?.success ?? false) {
        final store = response.result?.data?.toEntity();
        if (store != null) {
          return Success(store);
        } else {
          return const Error(DataFailure('Store data is null'));
        }
      } else {
        return Error(ServerFailure(response.result?.message ?? 'Something went wrong'));
      }
    } on NoInternetConnectionException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on BadCertificateException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.toString()));
    } on FormatException catch (e) {
      return Error(DataFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<StoreEntity>> createStore(StoreEntity store) async {
    try {
      final storeModel = StoreModel.fromEntity(store);
      final response = await storesDataSource.createStore(storeModel);
      
      if (response.result?.success ?? false) {
        final createdStore = response.result?.data?.toEntity();
        if (createdStore != null) {
          return Success(createdStore);
        } else {
          return const Error(DataFailure('Created store data is null'));
        }
      } else {
        return Error(ServerFailure(response.result?.message ?? 'Something went wrong'));
      }
    } on NoInternetConnectionException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on BadCertificateException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.toString()));
    } on FormatException catch (e) {
      return Error(DataFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<StoreEntity>> updateStore(StoreEntity store) async {
    try {
      final storeModel = StoreModel.fromEntity(store);
      final response = await storesDataSource.updateStore(storeModel);
      
      if (response.result?.success ?? false) {
        final updatedStore = response.result?.data?.toEntity();
        if (updatedStore != null) {
          return Success(updatedStore);
        } else {
          return const Error(DataFailure('Updated store data is null'));
        }
      } else {
        return Error(ServerFailure(response.result?.message ?? 'Something went wrong'));
      }
    } on NoInternetConnectionException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on BadCertificateException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.toString()));
    } on FormatException catch (e) {
      return Error(DataFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> deleteStore(int id) async {
    try {
      final response = await storesDataSource.deleteStore(id);
      final success = response['result']?['success'] as bool? ?? false;
      
      if (success) {
        return const Success(true);
      } else {
        final message = response['result']?['message'] as String? ?? 'Something went wrong';
        return Error(ServerFailure(message));
      }
    } on NoInternetConnectionException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on BadCertificateException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.toString()));
    } on FormatException catch (e) {
      return Error(DataFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<StoreEntity>>> searchStores(String query) async {
    try {
      final response = await storesDataSource.searchStores(query);
      
      if (response.result?.success ?? false) {
        final stores = response.result?.data?.map((model) => model.toEntity()).toList() ?? [];
        return Success(stores);
      } else {
        return Error(ServerFailure(response.result?.message ?? 'Something went wrong'));
      }
    } on NoInternetConnectionException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on BadCertificateException catch (e) {
      return Error(NetworkFailure(e.toString()));
    } on ServerException catch (e) {
      return Error(ServerFailure(e.toString()));
    } on FormatException catch (e) {
      return Error(DataFailure('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}
