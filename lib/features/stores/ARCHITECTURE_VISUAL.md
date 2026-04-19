# Stores Feature - Clean Architecture Visual Guide

## 📐 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                              │
│                     (UI, State Management, BLoC)                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌──────────────────┐    ┌──────────────────┐    ┌─────────────────┐  │
│  │  stores_demo     │    │  StoresBloc      │    │  stores_event   │  │
│  │  _screen.dart    │───▶│  (State Mgmt)    │◀───│  (7 Events)     │  │
│  │  (Demo UI)       │    │                  │    │                 │  │
│  └──────────────────┘    └────────┬─────────┘    └─────────────────┘  │
│                                   │                                     │
│                          ┌────────▼─────────┐                          │
│                          │  stores_state    │                          │
│                          │  (Immutable)     │                          │
│                          └──────────────────┘                          │
│                                   │                                     │
└───────────────────────────────────┼─────────────────────────────────────┘
                                    │ uses ↓
                                    │
┌───────────────────────────────────▼─────────────────────────────────────┐
│                           DOMAIN LAYER                                  │
│                  (Business Logic, Entities, Interfaces)                 │
│                         ⚠️  NO DEPENDENCIES                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌───────────────────────────────────────────────────────────────┐    │
│  │                        Use Cases                              │    │
│  │  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐  │    │
│  │  │ GetAllStores   │  │ GetStoreById   │  │ CreateStore    │  │    │
│  │  │    UseCase     │  │    UseCase     │  │    UseCase     │  │    │
│  │  └────────┬───────┘  └────────┬───────┘  └────────┬───────┘  │    │
│  │  ┌────────▼───────┐                      ┌────────▼───────┐  │    │
│  │  │ SearchStores   │                      │   (Business    │  │    │
│  │  │    UseCase     │                      │   Validation)  │  │    │
│  │  └────────────────┘                      └────────────────┘  │    │
│  └───────────────────────────────────────────────────────────────┘    │
│                                   │                                     │
│                          uses interface ▼                              │
│  ┌─────────────────────────────────────────────────────────────┐      │
│  │            IStoresRepository (Interface)                    │      │
│  │  + getAllStores(): Future<Result<List<StoreEntity>>>       │      │
│  │  + getStoreById(id): Future<Result<StoreEntity>>           │      │
│  │  + createStore(store): Future<Result<StoreEntity>>         │      │
│  │  + updateStore(store): Future<Result<StoreEntity>>         │      │
│  │  + deleteStore(id): Future<Result<bool>>                   │      │
│  │  + searchStores(query): Future<Result<List<StoreEntity>>>  │      │
│  └─────────────────────────────────────────────────────────────┘      │
│                                   ▲                                     │
│  ┌────────────────────────────────┼────────────────────────────┐      │
│  │            StoreEntity (Pure Dart Object)                   │      │
│  │  • id, name, address, city, country                         │      │
│  │  • phoneNumber, email, managerName                          │      │
│  │  • isActive, createdAt, description, employeeCount          │      │
│  └─────────────────────────────────────────────────────────────┘      │
│                                                                         │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    │ implements ↑
                                    │
┌───────────────────────────────────▼─────────────────────────────────────┐
│                            DATA LAYER                                   │
│              (Models, DataSources, API, Database)                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────┐      │
│  │         StoresRepository (Implementation)                   │      │
│  │  • Implements IStoresRepository interface                   │      │
│  │  • Converts Models ↔ Entities                               │      │
│  │  • Handles errors (Exception → Failure)                     │      │
│  │  • Maps Result types (Success/Error)                        │      │
│  └────────────────────────┬────────────────────────────────────┘      │
│                            │ uses ↓                                     │
│  ┌────────────────────────▼─────────────────────────────────┐         │
│  │           StoresDataSource                                │         │
│  │  • Contains 5 dummy stores                                │         │
│  │  • Simulates network delays (300-600ms)                   │         │
│  │  • CRUD operations with dummy data                        │         │
│  │  • Ready to swap with real ApiConsumer                    │         │
│  └───────────────────────────────────────────────────────────┘         │
│                            │                                            │
│                            │ returns ↓                                  │
│  ┌────────────────────────▼─────────────────────────────────┐         │
│  │              Data Models (DTOs)                           │         │
│  │  ┌──────────────────────────────────────────────────┐    │         │
│  │  │ StoreModel (JSON Serialization)                  │    │         │
│  │  │  • @JsonSerializable                             │    │         │
│  │  │  • toEntity() → StoreEntity                      │    │         │
│  │  │  • fromEntity(entity) → StoreModel               │    │         │
│  │  │  • fromJson() / toJson()                         │    │         │
│  │  └──────────────────────────────────────────────────┘    │         │
│  │  ┌──────────────────────────────────────────────────┐    │         │
│  │  │ StoresResponseModel                              │    │         │
│  │  │  • Wraps List<StoreModel>                        │    │         │
│  │  │  • Follows project's API structure               │    │         │
│  │  └──────────────────────────────────────────────────┘    │         │
│  │  ┌──────────────────────────────────────────────────┐    │         │
│  │  │ SingleStoreResponseModel                         │    │         │
│  │  │  • Wraps single StoreModel                       │    │         │
│  │  └──────────────────────────────────────────────────┘    │         │
│  └───────────────────────────────────────────────────────────┘         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow Diagram

```
┌─────────────┐
│    User     │
│  Interaction│
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                    1. Event Dispatch                        │
│  UI triggers: LoadAllStoresEvent, CreateStoreEvent, etc.   │
└──────┬──────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                    2. BLoC Processing                       │
│  • StoresBloc receives event                               │
│  • Calls appropriate use case                              │
│  • Emits loading state                                     │
└──────┬──────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                  3. Use Case Execution                      │
│  • GetAllStoresUseCase.execute()                           │
│  • Business validation (if needed)                         │
│  • Calls repository interface method                       │
└──────┬──────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│              4. Repository Implementation                   │
│  • StoresRepository.getAllStores()                         │
│  • Calls data source                                       │
│  • Converts Models → Entities                              │
│  • Maps errors to Failures                                 │
│  • Returns Result<List<StoreEntity>>                       │
└──────┬──────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                  5. Data Source Call                        │
│  • StoresDataSource.getAllStores()                         │
│  • Simulates network delay                                 │
│  • Returns StoresResponseModel with dummy data             │
│  (In real app: apiConsumer.get(Env.stores))                │
└──────┬──────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                  6. Response Processing                     │
│  • Models → Entities conversion                            │
│  • Success or Error Result                                 │
│  • Returns to repository → use case → BLoC                 │
└──────┬──────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                    7. State Emission                        │
│  • BLoC emits new state                                    │
│  • status: success/error                                   │
│  • stores: List<StoreEntity>                               │
│  • errorMessage: String (if error)                         │
└──────┬──────────────────────────────────────────────────────┘
       │
       ▼
┌─────────────────────────────────────────────────────────────┐
│                     8. UI Update                            │
│  • BlocBuilder rebuilds widget tree                        │
│  • Display stores list or error message                    │
│  • User sees updated UI                                    │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Dependency Direction Flow

```
Presentation ────────▶ Domain ◀──────── Data
    (UI)           (Business Logic)    (API/DB)

    ✅ Allowed: Presentation → Domain
    ✅ Allowed: Data → Domain
    ❌ Not Allowed: Domain → Presentation
    ❌ Not Allowed: Domain → Data
    ❌ Not Allowed: Data → Presentation
```

## 📦 Module Dependencies

```
┌────────────────────────────────────────────┐
│            External Packages               │
│  • flutter_bloc (state management)         │
│  • equatable (value comparison)            │
│  • json_annotation (serialization)         │
└────────────────────────────────────────────┘
                     ▲
                     │
        ┌────────────┼────────────┐
        │            │            │
        │            │            │
┌───────▼────┐ ┌─────▼─────┐ ┌──▼────────┐
│Presentation│ │  Domain   │ │   Data    │
│   Layer    │ │   Layer   │ │   Layer   │
│            │ │           │ │           │
│ • BLoC     │ │ • Entities│ │ • Models  │
│ • Events   │ │ • UseCases│ │ • Repos   │
│ • States   │ │ • Ifaces  │ │ • Sources │
│ • UI Demo  │ │           │ │           │
└────────────┘ └───────────┘ └───────────┘
```

## 🔐 Principles Applied

### 1. Single Responsibility Principle (SRP)
```
✅ StoreEntity: Only represents store data
✅ GetAllStoresUseCase: Only gets all stores
✅ StoresDataSource: Only handles data fetching
✅ StoresBloc: Only manages state
```

### 2. Open/Closed Principle (OCP)
```
✅ IStoresRepository interface allows new implementations
   without modifying existing code
✅ Can add MockStoresRepository for testing
✅ Can add CacheStoresRepository for offline mode
```

### 3. Liskov Substitution Principle (LSP)
```
✅ Any implementation of IStoresRepository can replace
   another without breaking the system
✅ StoresRepository, MockRepository, CacheRepository
   are all interchangeable
```

### 4. Interface Segregation Principle (ISP)
```
✅ IStoresRepository has only needed methods
✅ No client depends on unused methods
✅ Could split into IReadStores, IWriteStores if needed
```

### 5. Dependency Inversion Principle (DIP)
```
✅ High-level modules (UseCases) depend on abstractions
   (IStoresRepository), not concrete implementations
✅ Low-level modules (StoresRepository) implement
   abstractions
```

## 🧪 Testing Strategy

```
┌─────────────────────────────────────────────────────────┐
│                    Unit Tests                           │
├─────────────────────────────────────────────────────────┤
│  Domain Layer:                                          │
│    ✓ Test use cases with mock repositories             │
│    ✓ Test entity equality and copyWith                 │
│                                                         │
│  Data Layer:                                            │
│    ✓ Test model JSON serialization                     │
│    ✓ Test model ↔ entity conversion                    │
│    ✓ Test repository error handling                    │
│                                                         │
│  Presentation Layer:                                    │
│    ✓ Test BLoC state transitions                       │
│    ✓ Test event handling                               │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                 Integration Tests                       │
├─────────────────────────────────────────────────────────┤
│  ✓ Test complete flow: Event → BLoC → UseCase          │
│                        → Repository → DataSource        │
│  ✓ Test error propagation through layers               │
│  ✓ Test state updates with real dependencies           │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                   Widget Tests                          │
├─────────────────────────────────────────────────────────┤
│  ✓ Test UI with mocked BLoC states                     │
│  ✓ Test user interactions                              │
│  ✓ Test error message display                          │
└─────────────────────────────────────────────────────────┘
```

## 📚 Key Concepts Visualized

### Repository Pattern
```
┌──────────────┐
│   BLoC       │
└──────┬───────┘
       │ asks for data
       ▼
┌──────────────────────┐
│  IStoresRepository   │ ◀── Interface (contract)
│     (Interface)      │
└──────────────────────┘
       ▲
       │ implements
┌──────┴───────┐
│ StoresRepo   │ ◀── Implementation
│ (Concrete)   │
└──────┬───────┘
       │ fetches from
       ▼
┌──────────────┐
│ DataSource   │
└──────────────┘
```

### Result Pattern
```
sealed class Result<T>
    ├── Success<T>(data: T)
    └── Error<T>(failure: Failure)

Example:
Result<List<StoreEntity>> result = await repository.getAllStores();
switch (result) {
  case Success(:final data):
    // Use data
  case Error(:final failure):
    // Handle failure
}
```

### State Management Flow
```
Event ──▶ BLoC ──▶ emit(Loading)
                    │
                    ▼
                UseCase
                    │
                    ▼
                Repository
                    │
                    ▼
                DataSource
                    │
                    ▼
           Success / Error
                    │
                    ▼
         BLoC ──▶ emit(Success/Error)
                    │
                    ▼
                 UI Update
```

---

**This visual guide complements the README.md and provides a clear understanding of the architecture.**
