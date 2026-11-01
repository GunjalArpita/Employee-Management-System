import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeService {
  static const String baseUrl =
      'http://10.168.190.173:5000/api/employees';

  static Future<List<dynamic>> getEmployees() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load employees');
    }
  }
  // POST: Add employee

static Future<void> addEmployee(Map<String, String> employee) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(employee),
  );

  if (response.statusCode != 201) {
    final data = jsonDecode(response.body);
    throw Exception(data['message'] ?? 'Failed to add employee');
  }
}

static Future<void> updateEmployee(
    String id, Map<String, String> employee) async {
  final response = await http.put(
    Uri.parse('$baseUrl/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(employee),
  );

  if (response.statusCode != 200) {
    final data = jsonDecode(response.body);
    throw Exception(data['message'] ?? 'Failed to update employee');
  }
}

// DELETE: Delete employee
static Future<void> deleteEmployee(String id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/$id'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete employee: ${response.body}');
  }
}
}