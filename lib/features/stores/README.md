# Stores Feature - Clean Architecture Implementation

## Overview
This is a reference implementation of the **Stores** feature using **Clean Architecture** principles. The feature manages store entities with full CRUD operations using dummy data.

## 🏗️ Clean Architecture Layers

### 1. **Domain Layer** (`lib/features/stores/domain/`)
The innermost layer containing business logic and entities.

#### Entities (`entities/`)
- **`store_entity.dart`**: Core business object representing a Store
  - Independent of frameworks, UI, or data sources
  - Contains only business rules and data
  - Uses `Equatable` for value comparison

#### Repository Interfaces (`repositories/`)
- **`stores_repository_interface.dart`**: Abstract contract defining operations
  - Defines WHAT operations are available
  - Not HOW they are implemented
  - Follows **Dependency Inversion Principle**

#### Use Cases (`usecases/`)
Business logic operations encapsulated in single-responsibility classes:
- **`get_all_stores_usecase.dart`**: Retrieve all stores
- **`get_store_by_id_usecase.dart`**: Retrieve a specific store
- **`create_store_usecase.dart`**: Create a new store (with validation)
- **`search_stores_usecase.dart`**: Search stores by query

Each use case:
- Has a single responsibility
- Depends on repository interface (not implementation)
- Can contain business validation logic

### 2. **Data Layer** (`lib/features/stores/data/`)
Handles data operations and external dependencies.

#### Models (`models/`)
Data Transfer Objects (DTOs) for serialization:
- **`store_model.dart`**: JSON serialization/deserialization
  - Uses `json_annotation` for code generation
  - Converts between Entity (domain) and Model (data)
  - Handles API field naming (snake_case to camelCase)
- **`stores_response_model.dart`**: API response wrapper for list operations
- **`single_store_response_model.dart`**: API response wrapper for single store operations

#### Data Sources (`datasources/`)
- **`stores_datasource.dart`**: Data source with dummy data
  - Simulates API calls with network delays
  - Contains 5 dummy stores for testing
  - In real app: would use `ApiConsumer` to call actual APIs
  - Follows project's API response structure

#### Repository Implementation (`repositories/`)
- **`stores_repository_impl.dart`**: Concrete implementation of `IStoresRepository`
  - Implements all repository interface methods
  - Handles error mapping (exceptions → failures)
  - Converts models to entities
  - Follows project's error handling patterns

### 3. **Presentation Layer** (`lib/features/stores/presentation/`)
Manages UI state and user interactions.

#### BLoC (`bloc/`)
State management using BLoC pattern:
- **`stores_event.dart`**: Events that trigger state changes
  - `LoadAllStoresEvent`: Load all stores
  - `LoadStoreByIdEvent`: Load specific store
  - `SearchStoresEvent`: Search stores
  - `CreateStoreEvent`: Create new store
  - `UpdateStoreEvent`: Update existing store
  - `DeleteStoreEvent`: Delete store
  - `ResetStoresEvent`: Reset state

- **`stores_state.dart`**: Immutable state representation
  - Contains stores list, selected store, status, errors
  - Helper getters for state checks
  - Computed properties (activeStores, totalEmployeeCount)
  
- **`stores_bloc.dart`**: Business logic component
  - Receives events, processes them using use cases
  - Emits new states
  - Handles async operations
  - Manages state updates

## 🔄 Data Flow

```
UI/Widget (not created)
    ↓ (dispatches event)
StoresBloc
    ↓ (calls)
UseCase
    ↓ (calls)
Repository Interface
    ↓ (implemented by)
Repository Implementation
    ↓ (calls)
DataSource
    ↓ (returns)
Models → Entities → State → UI
```

## 📦 Dependencies Between Layers

```
Presentation → Domain ← Data
     ↓              ↑         ↓
  BLoC         UseCases   Repository
                   ↑           ↓
              Entities    DataSource
```

**Key Principle**: 
- Domain layer has NO dependencies (core business logic)
- Data and Presentation depend on Domain (through interfaces)
- Dependencies point INWARD (Dependency Inversion)

## 🎯 SOLID Principles Applied

1. **Single Responsibility Principle**
   - Each use case does one thing
   - Entities contain only business data
   - Repository handles only data operations

2. **Open/Closed Principle**
   - Repository interface allows new implementations without changing use cases
   - Can add new data sources without modifying existing code

3. **Liskov Substitution Principle**
   - Any implementation of `IStoresRepository` can be used interchangeably

4. **Interface Segregation Principle**
   - Repository interface contains only needed methods
   - No client is forced to depend on unused methods

5. **Dependency Inversion Principle**
   - High-level modules (use cases) depend on abstractions (interfaces)
   - Low-level modules (data sources) implement abstractions

## 🚀 How to Use This Feature

### 1. Setup (Dependency Injection)

```dart
// In your dependency injection setup (e.g., GetIt, Provider)
final storesDataSource = StoresDataSource();
final storesRepository = StoresRepository(storesDataSource);
final storesBloc = StoresBloc(repository: storesRepository);
```

### 2. Load All Stores

```dart
// Dispatch event
storesBloc.add(const LoadAllStoresEvent());

// Listen to state
BlocBuilder<StoresBloc, StoresState>(
  builder: (context, state) {
    if (state.isLoading) {
      return CircularProgressIndicator();
    }
    if (state.isSuccess) {
      return ListView.builder(
        itemCount: state.stores.length,
        itemBuilder: (context, index) {
          final store = state.stores[index];
          return ListTile(
            title: Text(store.name),
            subtitle: Text('${store.city}, ${store.country}'),
          );
        },
      );
    }
    if (state.isError) {
      return Text('Error: ${state.errorMessage}');
    }
    return Container();
  },
)
```

### 3. Search Stores

```dart
storesBloc.add(SearchStoresEvent('New York'));
```

### 4. Create a Store

```dart
storesBloc.add(
  CreateStoreEvent(
    name: 'New Store',
    address: '123 Main St',
    city: 'Boston',
    country: 'USA',
    phoneNumber: '+1-555-0199',
    email: 'newstore@example.com',
    managerName: 'Jane Doe',
    isActive: true,
    description: 'A new store location',
    employeeCount: 20,
  ),
);
```

### 5. Update a Store

```dart
storesBloc.add(
  UpdateStoreEvent(
    id: 1,
    name: 'Updated Store Name',
    address: '456 Updated St',
    city: 'New York',
    country: 'USA',
    phoneNumber: '+1-555-0101',
    email: 'updated@example.com',
    managerName: 'John Smith',
    isActive: true,
    createdAt: DateTime.parse('2024-01-15T10:00:00Z'),
    employeeCount: 50,
  ),
);
```

### 6. Delete a Store

```dart
storesBloc.add(DeleteStoreEvent(1));
```

### 7. Get a Specific Store

```dart
storesBloc.add(LoadStoreByIdEvent(1));

// Access selected store from state
final selectedStore = state.selectedStore;
```

## 📊 Dummy Data

The feature includes 5 dummy stores:

1. **Downtown Store** - New York (45 employees)
2. **Westside Mall Store** - Los Angeles (32 employees)
3. **Airport Branch** - Chicago (28 employees)
4. **Suburban Plaza** - Houston (inactive, 0 employees)
5. **Beach Front Store** - Miami (38 employees)

## 🔄 Switching to Real API

To use real API instead of dummy data:

1. **Update DataSource**:
   ```dart
   class StoresDataSource {
     StoresDataSource(this.apiConsumer);
     final ApiConsumer apiConsumer;

     Future<StoresResponseModel> getAllStores() async {
       final response = await apiConsumer.get(Env.stores);
       return StoresResponseModel.fromJson(response);
     }
     // ... implement other methods
   }
   ```

2. **Generate JSON serialization code**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **No changes needed in**:
   - Domain layer (entities, interfaces, use cases)
   - Presentation layer (BLoC, events, states)
   - Repository implementation (already handles conversions)

## 🧪 Testing Strategy

### Unit Tests
- **Domain Layer**: Test entities, use cases
- **Data Layer**: Test model conversions, repository error handling
- **Presentation Layer**: Test BLoC state transitions

### Integration Tests
- Test complete flow: Event → BLoC → UseCase → Repository → DataSource

### Widget Tests
- Test UI components with mocked BLoC states

## 📝 Key Takeaways

1. **Separation of Concerns**: Each layer has a distinct responsibility
2. **Testability**: Easy to test each layer independently with mocks
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: Easy to add new features following the same pattern
5. **Flexibility**: Can swap data sources, UI frameworks, or state management without affecting business logic

## 🎓 Learning Resources

- **Clean Architecture**: Robert C. Martin's "Clean Architecture" book
- **SOLID Principles**: Understanding object-oriented design
- **BLoC Pattern**: Flutter's recommended state management approach
- **Repository Pattern**: Abstracting data sources
- **Use Case Pattern**: Encapsulating business logic

## 🔗 Related Files

- Common utilities: `lib/common/networking/result.dart`
- Error handling: `lib/common/error/failures.dart`, `lib/common/error/exceptions.dart`
- API consumer: `lib/common/networking/api_consumer.dart` (for real API)

---

**Note**: This implementation serves as a reference for building other features in the application. Follow the same structure and principles for consistency across the codebase.
