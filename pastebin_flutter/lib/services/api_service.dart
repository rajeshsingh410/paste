import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  // CREATE PASTE
  static Future<Map<String, dynamic>> createPaste(
    String content,
    int? ttl,
    int? maxViews,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/pastes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "content": content,
        "ttl_seconds": ttl,     // ✅ int
        "max_views": maxViews, // ✅ int
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create paste");
    }
  }

  // GET PASTE
  static Future<Map<String, dynamic>> getPaste(String id) async {
    final response =
        await http.get(Uri.parse("$baseUrl/api/pastes/$id"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Paste expired or not found");
    }
  }
}
