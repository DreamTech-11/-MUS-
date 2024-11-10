import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class APIService extends GetxService {
  APIService._privateConstructor();
  static final APIService instance = APIService._privateConstructor();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<String?> getIdToken() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  Future<Map<String, String>> getHeaders() async {
    String? token = await getIdToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> createDreamPost(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/dreamposts/');
    final headers = await getHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );
    if (response.statusCode == 201) {
      print('Success: Dream post created');
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create dream post: ${response.body}');
    }
  }

  Future<Map<String,String>> gptQuery(String title, String content) async {
    final url = Uri.parse('$baseUrl/gpt-query/');
    final headers = await getHeaders();
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'title': title,
          'content': content,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final gptResponse = responseData['gpt_response'];
        final imageURl = responseData['image_url'];
        print('GPT Response: ${responseData['gpt_response']}');
        print('GPT Response: ${responseData['image_url']}');
        return {
          'content': gptResponse,
          'image_url':imageURl
        };
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to get GPT response: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getDreams(int year,int month) async {
    final url = Uri.parse('$baseUrl/dreamposts/by-month/${year}/${month}/');
    final headers = await getHeaders();
    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> dreamsJson = json.decode(utf8.decode(response.bodyBytes));
        print('Success: Retrieved ${dreamsJson.length} dreams');
        return dreamsJson;
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to get dreams: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred: $e');
      throw Exception('Failed to get dreams: $e');
    }
  }

  Future<void> deleteDream(int id) async{
    final url = Uri.parse('$baseUrl/dreamposts/$id/');
    final headers = await getHeaders();
    final response = await http.delete(
      url,
      headers: headers,
    );
    if (response.statusCode == 204) {
      print('Success: Dream post deleted');
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete dream post: ${response.body}');
    }
  }

  Future<void> updateDream(int id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$baseUrl/dreamposts/$id/');
    final headers = await getHeaders();
    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(updatedData),
    );
    if (response.statusCode == 200) {
      print('Success: Dream post updated');
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update dream post: ${response.body}');
    }
  }
}