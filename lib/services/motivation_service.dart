import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notifications_lesson/models/motivation.dart';

class MotivationService {
  Future<Motivation?> getMotivation() async {
    Uri url = Uri.parse("https://zenquotes.io/api/random");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> data =
          jsonDecode(response.body).cast<Map<String, dynamic>>();
      Motivation? motivation;
      if (data.isNotEmpty) {
        motivation = Motivation.fromJson(data[0]);
      }

      return motivation;
    }

    return null;
  }
}
