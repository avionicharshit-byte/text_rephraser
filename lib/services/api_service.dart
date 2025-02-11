import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  static const String _claudeBaseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _chatgptBaseUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<String> rephraseText(String text) async {
    final apiKey = await StorageService.getApiKey();
    final provider = await StorageService.getProvider();

    if (apiKey == null || provider == null) {
      throw Exception('API key or provider not found. Please set up the app first.');
    }

    try {
      if (provider == 'claude') {
        return await _rephraseWithClaude(text, apiKey);
      } else {
        return await _rephraseWithChatGPT(text, apiKey);
      }
    } catch (e) {
      throw Exception('Failed to rephrase text: $e');
    }
  }

  static Future<String> _rephraseWithClaude(String text, String apiKey) async {
    final response = await http.post(
      Uri.parse(_claudeBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-3-sonnet-20240229',
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content': 'Please rephrase this text to be more clear and grammatically correct: "$text"'
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content'][0]['text'];
    } else {
      throw Exception('Claude API error: ${response.body}');
    }
  }

  static Future<String> _rephraseWithChatGPT(String text, String apiKey) async {
    final response = await http.post(
      Uri.parse(_chatgptBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'user',
            'content': 'Please rephrase this text to be more clear and grammatically correct: "$text"'
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('ChatGPT API error: ${response.body}');
    }
  }
}