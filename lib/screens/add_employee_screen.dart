
import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Map<String, String>? employee;
  final bool isEdit;

  const AddEmployeeScreen({
    super.key,
    this.employee,
    this.isEdit = false,
  });

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final designationController = TextEditingController();
  final departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      nameController.text = widget.employee!['name']!;
      emailController.text = widget.employee!['email']!;
      mobileController.text = widget.employee!['mobile']!;
      designationController.text = widget.employee!['designation']!;
      departmentController.text = widget.employee!['department']!;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    designationController.dispose();
    departmentController.dispose();
    super.dispose();
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? customValidator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: customValidator ??
            (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Employee' : 'Add Employee'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // Name validation
              buildTextField(
                'Name',
                nameController,
                customValidator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Name';
                  }

                  if (!RegExp(r'^[a-zA-Z ]+$')
                      .hasMatch(value.trim())) {
                    return 'Name must contain only alphabets';
                  }

                  return null;
                },
              ),

              // Email validation
              buildTextField(
                'Email',
                emailController,
                keyboardType: TextInputType.emailAddress,
                customValidator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Email';
                  }

                  if (!RegExp(
                    r'^[\w.-]+@[\w.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
              ),

              // Mobile validation
              buildTextField(
                'Mobile',
                mobileController,
                keyboardType: TextInputType.phone,
                customValidator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter Mobile';
                  }

                  if (!RegExp(r'^[0-9]{10}$')
                      .hasMatch(value.trim())) {
                    return 'Mobile must contain exactly 10 digits';
                  }

                  return null;
                },
              ),

              // Designation validation
              buildTextField('Designation', designationController),

              // Department validation
              buildTextField('Department', departmentController),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final employee = {
                      'name': nameController.text.trim(),
                      'email': emailController.text.trim(),
                      'mobile': mobileController.text.trim(),
                      'designation': designationController.text.trim(),
                      'department': departmentController.text.trim(),
                    };

                    Navigator.pop(context, employee);
                  }
                },
                child: Text(
                  widget.isEdit ? 'Update Employee' : 'Save Employee',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
