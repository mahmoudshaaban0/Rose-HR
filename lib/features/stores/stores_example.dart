// ignore_for_file: avoid_print, document_ignores

import 'package:rose_hr/features/stores/data/datasources/stores_datasource.dart';
import 'package:rose_hr/features/stores/data/repositories/stores_repository_impl.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_bloc.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_event.dart';

/// Example usage of the Stores feature with dummy data
/// This demonstrates the clean architecture flow without UI
/// 
/// Run this to see the feature in action:
/// 1. All operations work with dummy data
/// 2. Demonstrates proper dependency injection
/// 3. Shows how events trigger state changes
/// 4. Illustrates clean separation of concerns

Future<void> runStoresExample() async {
  print('========================================');
  print('STORES FEATURE - CLEAN ARCHITECTURE DEMO');
  print('========================================\n');

  // STEP 1: Setup Dependencies (Dependency Injection)
  print('📦 Step 1: Setting up dependencies...');
  final dataSource = StoresDataSource();
  final repository = StoresRepository(dataSource);
  final bloc = StoresBloc(repository: repository);
  print('✅ Dependencies injected successfully\n');

  // STEP 2: Listen to state changes
  print('👂 Step 2: Subscribing to state changes...\n');
  bloc.stream.listen((state) {
    print('📊 State Update:');
    print('   Status: ${state.status}');
    print('   Total Stores: ${state.stores.length}');
    print('   Active Stores: ${state.activeStores.length}');
    print('   Total Employees: ${state.totalEmployeeCount}');
    if (state.errorMessage != null) {
      print('   ❌ Error: ${state.errorMessage}');
    }
    if (state.searchQuery != null) {
      print('   🔍 Search Query: "${state.searchQuery}"');
    }
    if (state.selectedStore != null) {
      print('   🎯 Selected Store: ${state.selectedStore!.name}');
    }
    print('');
  });

  // STEP 3: Load all stores
  print('🔄 Step 3: Loading all stores...');
  bloc.add(const LoadAllStoresEvent());
  await Future<void>.delayed(const Duration(milliseconds: 600));

  print('📋 Displaying stores:');
  final currentState = bloc.state;
  for (final store in currentState.stores) {
    final status = store.isActive ? '✅' : '⏸️';
    print('   $status ${store.name}');
    print('      📍 ${store.city}, ${store.country}');
    print('      👤 Manager: ${store.managerName}');
    print('      👥 Employees: ${store.employeeCount ?? 0}');
    print('      📧 ${store.email}');
    print('');
  }

  // STEP 4: Search stores
  print('🔍 Step 4: Searching stores by "New York"...');
  bloc.add(const SearchStoresEvent('New York'));
  await Future<void>.delayed(const Duration(milliseconds: 500));

  print('📋 Search results:');
  for (final store in bloc.state.stores) {
    print('   ✅ ${store.name} - ${store.city}');
  }
  print('');

  // STEP 5: Get a specific store
  print('🎯 Step 5: Getting store by ID (id: 2)...');
  bloc.add(const LoadStoreByIdEvent(2));
  await Future<void>.delayed(const Duration(milliseconds: 400));

  final selectedStore = bloc.state.selectedStore;
  if (selectedStore != null) {
    print('📋 Store Details:');
    print('   ID: ${selectedStore.id}');
    print('   Name: ${selectedStore.name}');
    print('   Address: ${selectedStore.address}');
    print('   City: ${selectedStore.city}, ${selectedStore.country}');
    print('   Phone: ${selectedStore.phoneNumber}');
    print('   Email: ${selectedStore.email}');
    print('   Manager: ${selectedStore.managerName}');
    print('   Status: ${selectedStore.isActive ? "Active" : "Inactive"}');
    print('   Description: ${selectedStore.description}');
    print('   Employees: ${selectedStore.employeeCount}');
    print('   Created: ${selectedStore.createdAt}');
  }
  print('');

  // STEP 6: Create a new store
  print('➕ Step 6: Creating a new store...');
  bloc.add(
    const CreateStoreEvent(
      name: 'Silicon Valley Hub',
      address: '1 Infinite Loop',
      city: 'Cupertino',
      country: 'USA',
      phoneNumber: '+1-555-0199',
      email: 'siliconvalley@example.com',
      managerName: 'Alice Cooper',
      isActive: true,
      description: 'Tech hub store in Silicon Valley',
      employeeCount: 50,
    ),
  );
  await Future<void>.delayed(const Duration(milliseconds: 500));

  print('✅ Store created successfully!');
  print('   Total stores now: ${bloc.state.stores.length}');
  print('');

  // STEP 7: Update a store
  print('✏️ Step 7: Updating a store (id: 1)...');
  final storeToUpdate = bloc.state.stores.firstWhere((s) => s.id == 1);
  bloc.add(
    UpdateStoreEvent(
      id: storeToUpdate.id,
      name: '${storeToUpdate.name} - UPDATED',
      address: storeToUpdate.address,
      city: storeToUpdate.city,
      country: storeToUpdate.country,
      phoneNumber: storeToUpdate.phoneNumber,
      email: storeToUpdate.email,
      managerName: storeToUpdate.managerName,
      isActive: storeToUpdate.isActive,
      createdAt: storeToUpdate.createdAt,
      description: 'This store has been updated',
      employeeCount: 60,
    ),
  );
  await Future<void>.delayed(const Duration(milliseconds: 500));

  print('✅ Store updated successfully!');
  final updatedStore = bloc.state.stores.firstWhere((s) => s.id == 1);
  print('   New name: ${updatedStore.name}');
  print('   New employee count: ${updatedStore.employeeCount}');
  print('');

  // STEP 8: Delete a store
  print('🗑️ Step 8: Deleting a store (id: 4)...');
  final storesBeforeDelete = bloc.state.stores.length;
  bloc.add(const DeleteStoreEvent(4));
  await Future<void>.delayed(const Duration(milliseconds: 400));

  print('✅ Store deleted successfully!');
  print('   Stores before delete: $storesBeforeDelete');
  print('   Stores after delete: ${bloc.state.stores.length}');
  print('');

  // STEP 9: Load all stores again to see final state
  print('🔄 Step 9: Loading all stores to see final state...');
  bloc.add(const LoadAllStoresEvent());
  await Future<void>.delayed(const Duration(milliseconds: 600));

  print('📊 Final Statistics:');
  print('   Total Stores: ${bloc.state.stores.length}');
  print('   Active Stores: ${bloc.state.activeStores.length}');
  print('   Inactive Stores: ${bloc.state.inactiveStores.length}');
  print('   Total Employees: ${bloc.state.totalEmployeeCount}');
  print('');

  print('📋 Final Store List:');
  for (var i = 0; i < bloc.state.stores.length; i++) {
    final store = bloc.state.stores[i];
    print('   ${i + 1}. ${store.name} (${store.city})');
  }
  print('');

  // STEP 10: Cleanup
  print('🧹 Step 10: Cleaning up...');
  await bloc.close();
  print('✅ BLoC closed\n');

  print('========================================');
  print('✅ DEMO COMPLETED SUCCESSFULLY!');
  print('========================================');
  print('');
  print('💡 Key Takeaways:');
  print('   ✅ Clean separation between Domain, Data, and Presentation');
  print('   ✅ Use cases encapsulate business logic');
  print('   ✅ Repository pattern abstracts data sources');
  print('   ✅ BLoC manages state in a predictable way');
  print('   ✅ Entities are independent of frameworks');
  print('   ✅ Easy to test each layer independently');
  print('   ✅ Easy to swap dummy data with real API');
  print('');
}

/// Uncomment the main function below to run this example standalone
/// Or call runStoresExample() from your app

// void main() async {
//   await runStoresExample();
// }
