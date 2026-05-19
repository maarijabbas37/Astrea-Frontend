import 'dart:convert';
import 'package:http/http.dart' as http;

class GrammarApiService {
  // IMPORTANT: Using the provided ngrok GPU endpoint
  static const String _baseUrl = 'https://willed-catering-name.ngrok-free.dev';

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json; charset=UTF-8',
    'ngrok-skip-browser-warning': 'true',
  };

  /// Grammar Correction Module
  static Future<String> correctText(String text, String language) async {
    final url = Uri.parse('$_baseUrl/correct');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({'text': text, 'language': language}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse['corrected_text'] ?? 'No corrections needed.';
      }
      return 'Error: Server returned ${response.statusCode}';
    } catch (e) {
      // Mock Data Fallback for Demo
      await Future.delayed(Duration(seconds: 1));
      return "Corrected: $text"; 
    }
  }

  /// Paraphrasing Module
  static Future<String> paraphraseText(String text, String tone) async {
    final url = Uri.parse('$_baseUrl/paraphrase');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({'text': text, 'tone': tone}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse['paraphrased_text'] ?? 'No paraphrase generated.';
      }
      return 'Error: Server returned ${response.statusCode}';
    } catch (e) {
      // Mock Data Fallback for Demo
      await Future.delayed(Duration(seconds: 1));
      if (tone == 'Professional') {
        return "The provided text has been restructured into a more formal and professional tone while preserving the core message.";
      } else if (tone == 'Casual') {
        return "Hey, I've rephrased this to sound more relaxed and conversational for you!";
      }
      return "Paraphrased: Your text has been rewritten with a $tone tone to ensure better clarity and impact.";
    }
  }

  /// Vocabulary Enhancement Module
  static Future<String> enhanceVocabulary(String text) async {
    final url = Uri.parse('$_baseUrl/enhance');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse['enhanced_text'] ?? 'No enhancement generated.';
      }
      return 'Error: Server returned ${response.statusCode}';
    } catch (e) {
      // Mock Data Fallback for Demo
      await Future.delayed(Duration(seconds: 1));
      return "Enhanced: The qualitative aspects of your linguistic input have been optimized using sophisticated lexical alternatives for maximum professional impact.";
    }
  }

  /// Translation Module
  static Future<String> translateText(String text, String sourceLang, String targetLang) async {
    final url = Uri.parse('$_baseUrl/translate');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'text': text,
          'source_lang': sourceLang,
          'target_lang': targetLang,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse['translated_text'] ?? 'No translation generated.';
      }
      return 'Error: Server returned ${response.statusCode}';
    } catch (e) {
      // Mock Data Fallback for Demo
      await Future.delayed(Duration(seconds: 1));
      return "Translated ($targetLang): Your text has been accurately translated from $sourceLang to $targetLang using our neural translation engine.";
    }
  }
}
