import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/common/networking/result.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';
import 'package:rose_hr/features/stores/domain/repositories/stores_repository_interface.dart';
import 'package:rose_hr/features/stores/domain/usecases/create_store_usecase.dart';
import 'package:rose_hr/features/stores/domain/usecases/get_all_stores_usecase.dart';
import 'package:rose_hr/features/stores/domain/usecases/get_store_by_id_usecase.dart';
import 'package:rose_hr/features/stores/domain/usecases/search_stores_usecase.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_event.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_state.dart';

/// BLoC for managing stores feature state
/// Uses use cases to interact with the domain layer
/// Following BLoC pattern for state management and separation of concerns
class StoresBloc extends Bloc<StoresEvent, StoresState> {
  StoresBloc({
    required IStoresRepository repository,
  })  : _getAllStoresUseCase = GetAllStoresUseCase(repository),
        _getStoreByIdUseCase = GetStoreByIdUseCase(repository),
        _createStoreUseCase = CreateStoreUseCase(repository),
        _searchStoresUseCase = SearchStoresUseCase(repository),
        _repository = repository,
        super(const StoresState()) {
    on<LoadAllStoresEvent>(_onLoadAllStores);
    on<LoadStoreByIdEvent>(_onLoadStoreById);
    on<SearchStoresEvent>(_onSearchStores);
    on<CreateStoreEvent>(_onCreateStore);
    on<UpdateStoreEvent>(_onUpdateStore);
    on<DeleteStoreEvent>(_onDeleteStore);
    on<ResetStoresEvent>(_onResetStores);
  }

  final GetAllStoresUseCase _getAllStoresUseCase;
  final GetStoreByIdUseCase _getStoreByIdUseCase;
  final CreateStoreUseCase _createStoreUseCase;
  final SearchStoresUseCase _searchStoresUseCase;
  final IStoresRepository _repository;

  /// Load all stores
  Future<void> _onLoadAllStores(
    LoadAllStoresEvent event,
    Emitter<StoresState> emit,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: StoresStatus.loading));

    final result = await _getAllStoresUseCase.execute();

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: StoresStatus.success,
            stores: data,
            searchQuery: null,
          ),
        );
      case Error(:final failure):
        emit(
          state.copyWith(
            status: StoresStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Load a specific store by ID
  Future<void> _onLoadStoreById(
    LoadStoreByIdEvent event,
    Emitter<StoresState> emit,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: StoresStatus.loading));

    final result = await _getStoreByIdUseCase.execute(event.storeId);

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: StoresStatus.success,
            selectedStore: data,
          ),
        );
      case Error(:final failure):
        emit(
          state.copyWith(
            status: StoresStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Search stores by query
  Future<void> _onSearchStores(
    SearchStoresEvent event,
    Emitter<StoresState> emit,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: StoresStatus.searching));

    final result = await _searchStoresUseCase.execute(event.query);

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: StoresStatus.success,
            stores: data,
            searchQuery: event.query,
          ),
        );
      case Error(:final failure):
        emit(
          state.copyWith(
            status: StoresStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Create a new store
  Future<void> _onCreateStore(
    CreateStoreEvent event,
    Emitter<StoresState> emit,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: StoresStatus.creating));

    try {
      // Create entity from event data
      final newStore = StoreEntity(
        id: 0, // Will be assigned by backend/datasource
        name: event.name,
        address: event.address,
        city: event.city,
        country: event.country,
        phoneNumber: event.phoneNumber,
        email: event.email,
        managerName: event.managerName,
        isActive: event.isActive,
        createdAt: DateTime.now(),
        description: event.description,
        employeeCount: event.employeeCount,
      );

      final result = await _createStoreUseCase.execute(newStore);

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          // Add the created store to the list
          final updatedStores = [...state.stores, data];
          emit(
            state.copyWith(
              status: StoresStatus.created,
              stores: updatedStores,
              selectedStore: data,
            ),
          );
        case Error(:final failure):
          emit(
            state.copyWith(
              status: StoresStatus.error,
              errorMessage: failure.message,
            ),
          );
      }
    } on Exception catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: StoresStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Update an existing store
  Future<void> _onUpdateStore(
    UpdateStoreEvent event,
    Emitter<StoresState> emit,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: StoresStatus.updating));

    try {
      final updatedStore = StoreEntity(
        id: event.id,
        name: event.name,
        address: event.address,
        city: event.city,
        country: event.country,
        phoneNumber: event.phoneNumber,
        email: event.email,
        managerName: event.managerName,
        isActive: event.isActive,
        createdAt: event.createdAt,
        description: event.description,
        employeeCount: event.employeeCount,
      );

      final result = await _repository.updateStore(updatedStore);

      if (isClosed) return;

      switch (result) {
        case Success(:final data):
          // Update the store in the list
          final updatedStores = state.stores.map((store) {
            return store.id == data.id ? data : store;
          }).toList();

          emit(
            state.copyWith(
              status: StoresStatus.updated,
              stores: updatedStores,
              selectedStore: data,
            ),
          );
        case Error(:final failure):
          emit(
            state.copyWith(
              status: StoresStatus.error,
              errorMessage: failure.message,
            ),
          );
      }
    } on Exception catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: StoresStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Delete a store
  Future<void> _onDeleteStore(
    DeleteStoreEvent event,
    Emitter<StoresState> emit,
  ) async {
    if (isClosed) return;
    emit(state.copyWith(status: StoresStatus.deleting));

    final result = await _repository.deleteStore(event.storeId);

    if (isClosed) return;

    switch (result) {
      case Success():
        // Remove the store from the list
        final updatedStores = state.stores.where((store) => store.id != event.storeId).toList();

        emit(
          state.copyWith(
            status: StoresStatus.deleted,
            stores: updatedStores,
            selectedStore: state.selectedStore?.id == event.storeId ? null : state.selectedStore,
          ),
        );
      case Error(:final failure):
        emit(
          state.copyWith(
            status: StoresStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Reset the BLoC state to initial
  void _onResetStores(
    ResetStoresEvent event,
    Emitter<StoresState> emit,
  ) {
    if (isClosed) return;
    emit(const StoresState());
  }
}
