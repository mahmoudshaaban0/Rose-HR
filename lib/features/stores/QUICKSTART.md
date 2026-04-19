# Stores Feature - Quick Start Guide

## 🚀 Quick Start

### 1. View the Demo

To see the feature in action with a UI:

```dart
import 'package:rose_hr/features/stores/presentation/demo/stores_demo_screen.dart';

// Navigate to the demo screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const StoresDemoScreen()),
);
```

### 2. Basic Usage (Without UI)

```dart
import 'package:rose_hr/features/stores/data/datasources/stores_datasource.dart';
import 'package:rose_hr/features/stores/data/repositories/stores_repository_impl.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_bloc.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_event.dart';

void main() async {
  // Setup dependencies
  final dataSource = StoresDataSource();
  final repository = StoresRepository(dataSource);
  final bloc = StoresBloc(repository: repository);

  // Load all stores
  bloc.add(const LoadAllStoresEvent());

  // Listen to state changes
  bloc.stream.listen((state) {
    if (state.isSuccess) {
      print('Loaded ${state.stores.length} stores');
      for (var store in state.stores) {
        print('- ${store.name} (${store.city})');
      }
    }
  });
}
```

## 📋 Common Operations

### Load All Stores
```dart
bloc.add(const LoadAllStoresEvent());
```

### Search Stores
```dart
bloc.add(SearchStoresEvent('New York'));
```

### Get Store by ID
```dart
bloc.add(LoadStoreByIdEvent(1));
```

### Create Store
```dart
bloc.add(
  CreateStoreEvent(
    name: 'New Store',
    address: '123 Main St',
    city: 'Boston',
    country: 'USA',
    phoneNumber: '+1-555-0199',
    email: 'newstore@example.com',
    managerName: 'Jane Doe',
    isActive: true,
  ),
);
```

### Update Store
```dart
final store = state.stores.first; // Get existing store
bloc.add(
  UpdateStoreEvent(
    id: store.id,
    name: 'Updated Name',
    address: store.address,
    city: store.city,
    country: store.country,
    phoneNumber: store.phoneNumber,
    email: store.email,
    managerName: store.managerName,
    isActive: true,
    createdAt: store.createdAt,
  ),
);
```

### Delete Store
```dart
bloc.add(DeleteStoreEvent(1));
```

## 🎯 State Management

### Check State Status
```dart
BlocBuilder<StoresBloc, StoresState>(
  builder: (context, state) {
    if (state.isLoading) {
      return LoadingWidget();
    }
    if (state.isError) {
      return ErrorWidget(message: state.errorMessage);
    }
    if (state.isSuccess) {
      return StoresListWidget(stores: state.stores);
    }
    return Container();
  },
)
```

### Listen to State Changes
```dart
BlocListener<StoresBloc, StoresState>(
  listener: (context, state) {
    if (state.isCreated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Store created!')),
      );
    }
    if (state.isError) {
      showErrorDialog(context, state.errorMessage);
    }
  },
  child: YourWidget(),
)
```

## 📊 Accessing State Data

```dart
// Get all stores
final allStores = state.stores;

// Get active stores only
final activeStores = state.activeStores;

// Get inactive stores only
final inactiveStores = state.inactiveStores;

// Get total employee count
final totalEmployees = state.totalEmployeeCount;

// Get selected store (after LoadStoreByIdEvent)
final selectedStore = state.selectedStore;

// Get search query
final query = state.searchQuery;
```

## 🔧 Dependency Injection Setup

### Using GetIt (Recommended)

```dart
// In your dependency injection setup file
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupStoresDependencies() {
  // Register data source
  getIt.registerLazySingleton<StoresDataSource>(
    () => StoresDataSource(),
  );

  // Register repository
  getIt.registerLazySingleton<IStoresRepository>(
    () => StoresRepository(getIt<StoresDataSource>()),
  );

  // Register BLoC (as factory for multiple instances)
  getIt.registerFactory<StoresBloc>(
    () => StoresBloc(repository: getIt<IStoresRepository>()),
  );
}

// In your widget
BlocProvider(
  create: (context) => getIt<StoresBloc>()..add(const LoadAllStoresEvent()),
  child: YourWidget(),
)
```

### Using Provider

```dart
MultiRepositoryProvider(
  providers: [
    RepositoryProvider(
      create: (context) => StoresRepository(StoresDataSource()),
    ),
  ],
  child: MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => StoresBloc(
          repository: context.read<StoresRepository>(),
        )..add(const LoadAllStoresEvent()),
      ),
    ],
    child: YourApp(),
  ),
)
```

## 🧪 Testing Examples

### Unit Test - Use Case
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockStoresRepository extends Mock implements IStoresRepository {}

void main() {
  test('GetAllStoresUseCase returns stores successfully', () async {
    // Arrange
    final repository = MockStoresRepository();
    final useCase = GetAllStoresUseCase(repository);
    final mockStores = [
      StoreEntity(
        id: 1,
        name: 'Test Store',
        // ... other fields
      ),
    ];
    
    when(() => repository.getAllStores())
        .thenAnswer((_) async => Success(mockStores));
    
    // Act
    final result = await useCase.execute();
    
    // Assert
    expect(result, isA<Success<List<StoreEntity>>>());
    final success = result as Success<List<StoreEntity>>;
    expect(success.data.length, 1);
    expect(success.data.first.name, 'Test Store');
  });
}
```

### BLoC Test
```dart
import 'package:bloc_test/bloc_test.dart';

void main() {
  blocTest<StoresBloc, StoresState>(
    'emits [loading, success] when LoadAllStoresEvent is added',
    build: () {
      final repository = MockStoresRepository();
      when(() => repository.getAllStores())
          .thenAnswer((_) async => Success(mockStores));
      return StoresBloc(repository: repository);
    },
    act: (bloc) => bloc.add(const LoadAllStoresEvent()),
    expect: () => [
      const StoresState(status: StoresStatus.loading),
      StoresState(
        status: StoresStatus.success,
        stores: mockStores,
      ),
    ],
  );
}
```

## 🔄 Switching from Dummy Data to Real API

1. **Update the DataSource** to use `ApiConsumer`:

```dart
class StoresDataSource {
  StoresDataSource(this.apiConsumer);
  final ApiConsumer apiConsumer;

  Future<StoresResponseModel> getAllStores() async {
    final response = await apiConsumer.get(Env.stores);
    return StoresResponseModel.fromJson(response as Map<String, dynamic>);
  }
  
  // Update other methods similarly...
}
```

2. **Update dependency injection**:

```dart
getIt.registerLazySingleton<StoresDataSource>(
  () => StoresDataSource(getIt<ApiConsumer>()),
);
```

3. **No other changes needed!** The rest of the architecture remains the same.

## 📝 File Structure Reference

```
lib/features/stores/
├── data/
│   ├── datasources/
│   │   └── stores_datasource.dart          # Data source with dummy data
│   ├── models/
│   │   ├── store_model.dart                # JSON model
│   │   ├── store_model.g.dart              # Generated
│   │   ├── stores_response_model.dart      # API response wrapper
│   │   ├── stores_response_model.g.dart    # Generated
│   │   ├── single_store_response_model.dart
│   │   └── single_store_response_model.g.dart
│   └── repositories/
│       └── stores_repository_impl.dart     # Repository implementation
├── domain/
│   ├── entities/
│   │   └── store_entity.dart               # Business entity
│   ├── repositories/
│   │   └── stores_repository_interface.dart # Repository contract
│   └── usecases/
│       ├── get_all_stores_usecase.dart
│       ├── get_store_by_id_usecase.dart
│       ├── create_store_usecase.dart
│       └── search_stores_usecase.dart
├── presentation/
│   ├── bloc/
│   │   ├── stores_bloc.dart                # BLoC implementation
│   │   ├── stores_event.dart               # Events
│   │   └── stores_state.dart               # States
│   └── demo/
│       └── stores_demo_screen.dart         # Demo UI (reference)
├── README.md                               # Full documentation
└── QUICKSTART.md                           # This file
```

## 🎓 Next Steps

1. **Read the full documentation**: Check `README.md` for detailed architecture explanation
2. **Run the demo**: Try out the demo screen to see all operations in action
3. **Create your own feature**: Use this as a template for new features
4. **Write tests**: Add unit, widget, and integration tests
5. **Connect to real API**: Replace dummy data with actual API calls

## 💡 Tips

- Always use events to trigger state changes, never modify state directly
- Use `isClosed` checks in BLoC to prevent emissions after dispose
- Leverage state helper getters like `isLoading`, `isSuccess`
- Use `BlocConsumer` when you need both builder and listener
- Keep business logic in use cases, not in BLoC or UI
- Test each layer independently for better maintainability

## 📞 Need Help?

- Review the comprehensive `README.md` for architecture details
- Check the demo screen implementation for UI examples
- Look at existing features (auth, holiday_request) for real-world patterns
- Refer to Flutter BLoC documentation: https://bloclibrary.dev

---

Happy coding! 🚀
