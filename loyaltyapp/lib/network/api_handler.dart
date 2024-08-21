import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://loyalty-app-pnwx.onrender.com/api';

  static Future<List<String>> fetchCategories(String token) async {
    final url = Uri.parse('$baseUrl/category');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      if (data is Map && data['result'] is List) {
        return List<String>.from(data['result'].map((item) => item['title']));
      } else {
        throw Exception('Unexpected data format for categories');
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchLoyaltyCards(String token,
      {String? category}) async {
    final url = Uri.parse('$baseUrl/loyalitycard');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map && data.containsKey('result')) {
        return List<Map<String, dynamic>>.from(data['result']);
      } else {
        throw Exception('Unexpected data format for loyalty cards');
      }
    } else {
      throw Exception('Failed to load loyalty cards');
    }
  }

  static Future<Map<String, dynamic>> checkOtp(
    String token, {
    required String loyaltyId,
    required String otp,
    String clientId = 'Test123',
    Map<String, dynamic>? note,
  }) async {
    final url = Uri.parse('$baseUrl/redeemcard/otpCheck');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'loyalityId': loyaltyId,
        'otp': otp,
        'clientId': clientId,
        'note': note ?? {},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // Return the response data directly
    } else {
      throw Exception('Failed to redeem loyalty card');
    }
  }

  static Future<Map<String, dynamic>> fetchLoyaltyCardData(
      String token, String id) async {
    final url = Uri.parse('$baseUrl/loyalitycard/$id');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // Return the response data directly
    } else {
      throw Exception('Failed to fetch loyalty card data');
    }
  }
}
