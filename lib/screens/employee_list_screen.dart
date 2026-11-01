
import 'package:flutter/material.dart';
import '../services/employee_service.dart';
import 'add_employee_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() =>
      _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Map<String, String>> employees = [];

  bool isLoading = true;
  String? errorMessage;

  // Fetch employees when screen opens
  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  // GET API - Fetch all employees
  Future<void> loadEmployees() async {
    try {
      final data = await EmployeeService.getEmployees();

      if (!mounted) return;

      setState(() {
        employees = data.map<Map<String, String>>((item) {
          return Map<String, String>.from(
            item.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
          );
        }).toList();

        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: const Text('Employee Management'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      // EMPLOYEE LIST
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!),
                )
              : employees.isEmpty
                  ? const Center(
                      child: Text('No Employees Found'),
                    )
                  : ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];

                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),

                            title: Text(employee['name']!),

                            subtitle: Text(
                              '${employee['designation']} - '
                              '${employee['department']}\n'
                              '${employee['email']}',
                            ),

                            isThreeLine: true,

                            // EDIT AND DELETE BUTTONS
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // EDIT BUTTON
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    final updatedEmployee =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddEmployeeScreen(
                                          employee: employee,
                                          isEdit: true,
                                        ),
                                      ),
                                    );

                                    if (updatedEmployee != null) {
                                      try {
                                        // Get employee ID
                                        final id = employee['id']!;

                                        // Call PUT API
                                        await EmployeeService.updateEmployee(
                                          id,
                                          Map<String, String>.from(
                                            updatedEmployee,
                                          ),
                                        );

                                        // Refresh employee list
                                        await loadEmployees();

                                        if (!mounted) return;

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Employee updated successfully!',
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        if (!mounted) return;

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
  content: Text(e.toString().replaceFirst('Exception: ', '')),
  backgroundColor: Colors.red,
)
                                        );
                                      }
                                    }
                                  },
                                ),

                                // DELETE BUTTON
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) =>
                                          AlertDialog(
                                        title: const Text(
                                          'Delete Employee',
                                        ),
                                        content: const Text(
                                          'Are you sure you want to delete this employee?',
                                        ),
                                        actions: [
                                          // CANCEL BUTTON
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(dialogContext);
                                            },
                                            child: const Text('Cancel'),
                                          ),

                                          // CONFIRM DELETE BUTTON
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(dialogContext);

                                              try {
                                                // Get employee ID
                                                final id = employee['id']!;

                                                // Call DELETE API
                                                await EmployeeService
                                                    .deleteEmployee(id);

                                                // Refresh employee list
                                                await loadEmployees();

                                                if (!mounted) return;

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Employee deleted successfully!',
                                                    ),
                                                  ),
                                                );
                                              } catch (e) {
                                                if (!mounted) return;

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(  e.toString().replaceFirst('Exception: ', ''),),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

      // ADD EMPLOYEE BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final employee = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEmployeeScreen(),
            ),
          );

          if (employee != null) {
            try {
              // Call POST API
              await EmployeeService.addEmployee(
                Map<String, String>.from(employee),
              );

              // Refresh employee list
              await loadEmployees();

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Employee added successfully!'),
                ),
              );
            } catch (e) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        e.toString().replaceFirst('Exception: ', ''),
      ),
      backgroundColor: Colors.red,
    ),
  );
}
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
