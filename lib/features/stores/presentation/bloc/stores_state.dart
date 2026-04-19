import 'package:equatable/equatable.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';

/// Enum representing different states of the Stores BLoC
enum StoresStatus {
  initial,
  loading,
  success,
  error,
  creating,
  created,
  updating,
  updated,
  deleting,
  deleted,
  searching,
}

/// State class for Stores BLoC
/// Using Equatable for value equality comparison
class StoresState extends Equatable {
  const StoresState({
    this.status = StoresStatus.initial,
    this.stores = const [],
    this.selectedStore,
    this.errorMessage,
    this.searchQuery,
  });

  final StoresStatus status;
  final List<StoreEntity> stores;
  final StoreEntity? selectedStore;
  final String? errorMessage;
  final String? searchQuery;

  @override
  List<Object?> get props => [
        status,
        stores,
        selectedStore,
        errorMessage,
        searchQuery,
      ];

  /// Creates a copy of the state with updated values
  StoresState copyWith({
    StoresStatus? status,
    List<StoreEntity>? stores,
    Object? selectedStore = _undefined,
    Object? errorMessage = _undefined,
    Object? searchQuery = _undefined,
  }) {
    return StoresState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      selectedStore: selectedStore == _undefined ? this.selectedStore : selectedStore as StoreEntity?,
      errorMessage: errorMessage == _undefined ? this.errorMessage : errorMessage as String?,
      searchQuery: searchQuery == _undefined ? this.searchQuery : searchQuery as String?,
    );
  }

  /// Helper getters for common state checks
  bool get isLoading => status == StoresStatus.loading;
  bool get isSuccess => status == StoresStatus.success;
  bool get isError => status == StoresStatus.error;
  bool get isCreating => status == StoresStatus.creating;
  bool get isCreated => status == StoresStatus.created;
  bool get isUpdating => status == StoresStatus.updating;
  bool get isUpdated => status == StoresStatus.updated;
  bool get isDeleting => status == StoresStatus.deleting;
  bool get isDeleted => status == StoresStatus.deleted;
  bool get isSearching => status == StoresStatus.searching;

  /// Get active stores only
  List<StoreEntity> get activeStores => stores.where((store) => store.isActive).toList();

  /// Get inactive stores only
  List<StoreEntity> get inactiveStores => stores.where((store) => !store.isActive).toList();

  /// Get total employee count across all stores
  int get totalEmployeeCount {
    return stores.fold(0, (sum, store) => sum + (store.employeeCount ?? 0));
  }
}

/// Sentinel value for copyWith to distinguish between "not provided" and "set to null"
const _undefined = Object();
