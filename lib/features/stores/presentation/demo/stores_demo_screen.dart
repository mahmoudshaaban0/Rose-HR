import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rose_hr/features/stores/data/datasources/stores_datasource.dart';
import 'package:rose_hr/features/stores/data/repositories/stores_repository_impl.dart';
import 'package:rose_hr/features/stores/domain/entities/store_entity.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_bloc.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_event.dart';
import 'package:rose_hr/features/stores/presentation/bloc/stores_state.dart';

/// Demo screen showing how to use the Stores feature
/// This is a reference implementation - not for production use
/// 
/// To use this demo:
/// 1. Import this file where needed
/// 2. Navigate to StoresDemoScreen
/// 3. Explore CRUD operations with dummy data
class StoresDemoScreen extends StatelessWidget {
  const StoresDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Dependency injection setup
        final dataSource = StoresDataSource();
        final repository = StoresRepository(dataSource);
        return StoresBloc(repository: repository)
          ..add(const LoadAllStoresEvent());
      },
      child: const _StoresDemoView(),
    );
  }
}

class _StoresDemoView extends StatefulWidget {
  const _StoresDemoView();

  @override
  State<_StoresDemoView> createState() => _StoresDemoViewState();
}

class _StoresDemoViewState extends State<_StoresDemoView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stores Demo - Clean Architecture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<StoresBloc>().add(const LoadAllStoresEvent());
            },
            tooltip: 'Refresh stores',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search stores by name or city...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<StoresBloc>().add(const LoadAllStoresEvent());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (query) {
                if (query.isNotEmpty) {
                  context.read<StoresBloc>().add(SearchStoresEvent(query));
                } else {
                  context.read<StoresBloc>().add(const LoadAllStoresEvent());
                }
              },
            ),
          ),

          // Stats section
          BlocBuilder<StoresBloc, StoresState>(
            builder: (context, state) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCard(
                      label: 'Total Stores',
                      value: state.stores.length.toString(),
                      icon: Icons.store,
                    ),
                    _StatCard(
                      label: 'Active',
                      value: state.activeStores.length.toString(),
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                    _StatCard(
                      label: 'Employees',
                      value: state.totalEmployeeCount.toString(),
                      icon: Icons.people,
                      color: Colors.orange,
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Stores list
          Expanded(
            child: BlocConsumer<StoresBloc, StoresState>(
              listener: (context, state) {
                if (state.isCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Store created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                if (state.isUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Store updated successfully!'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                if (state.isDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Store deleted successfully!'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
                if (state.isError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.errorMessage}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading || state.isSearching) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.isError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage ?? 'Unknown error occurred',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<StoresBloc>().add(const LoadAllStoresEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.stores.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          state.searchQuery != null
                              ? 'No stores found for "${state.searchQuery}"'
                              : 'No stores available',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.stores.length,
                  itemBuilder: (context, index) {
                    final store = state.stores[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: store.isActive ? Colors.green : Colors.grey,
                          child: Icon(
                            store.isActive ? Icons.store : Icons.store_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          store.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('${store.city}, ${store.country}'),
                            Text('Manager: ${store.managerName}'),
                            if (store.employeeCount != null)
                              Text('Employees: ${store.employeeCount}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                _showStoreDetails(context, store);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                _confirmDelete(context, store.id, store.name);
                              },
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateStoreDialog(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Store'),
      ),
    );
  }

  void _showStoreDetails(BuildContext context, StoreEntity store) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(store.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: 'ID', value: store.id.toString()),
              _DetailRow(label: 'Address', value: store.address),
              _DetailRow(label: 'City', value: store.city),
              _DetailRow(label: 'Country', value: store.country),
              _DetailRow(label: 'Phone', value: store.phoneNumber),
              _DetailRow(label: 'Email', value: store.email),
              _DetailRow(label: 'Manager', value: store.managerName),
              _DetailRow(label: 'Status', value: store.isActive ? 'Active' : 'Inactive'),
              if (store.description != null)
                _DetailRow(label: 'Description', value: store.description!),
              if (store.employeeCount != null)
                _DetailRow(label: 'Employees', value: store.employeeCount.toString()),
              _DetailRow(
                label: 'Created',
                value: store.createdAt.toString().split('.').first,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int storeId, String storeName) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Store'),
        content: Text('Are you sure you want to delete "$storeName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<StoresBloc>().add(DeleteStoreEvent(storeId));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreateStoreDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final countryController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final managerController = TextEditingController();
    final descriptionController = TextEditingController();
    final employeeCountController = TextEditingController();
    var isActive = true;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create New Store'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Store Name *'),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address *'),
                ),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City *'),
                ),
                TextField(
                  controller: countryController,
                  decoration: const InputDecoration(labelText: 'Country *'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number *'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email *'),
                ),
                TextField(
                  controller: managerController,
                  decoration: const InputDecoration(labelText: 'Manager Name *'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: employeeCountController,
                  decoration: const InputDecoration(labelText: 'Employee Count'),
                  keyboardType: TextInputType.number,
                ),
                SwitchListTile(
                  title: const Text('Active'),
                  value: isActive,
                  onChanged: (value) {
                    setState(() => isActive = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    cityController.text.isEmpty ||
                    countryController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    managerController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                context.read<StoresBloc>().add(
                      CreateStoreEvent(
                        name: nameController.text,
                        address: addressController.text,
                        city: cityController.text,
                        country: countryController.text,
                        phoneNumber: phoneController.text,
                        email: emailController.text,
                        managerName: managerController.text,
                        isActive: isActive,
                        description: descriptionController.text.isEmpty
                            ? null
                            : descriptionController.text,
                        employeeCount: employeeCountController.text.isEmpty
                            ? null
                            : int.tryParse(employeeCountController.text),
                      ),
                    );
                Navigator.pop(dialogContext);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.blue, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
