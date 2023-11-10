import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class LocationSuggestions {
  static final String androidKey = 'AIzaSyD1BF9DbQvvuJ13mBHexKpNeYoH8rOSGeg';
  static final String iosKey = 'AIzaSyD1BF9DbQvvuJ13mBHexKpNeYoH8rOSGeg';
  static final apiKey = Platform.isAndroid ? androidKey : iosKey;

  static Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&key=$apiKey';
    final dio = Dio(
      BaseOptions(
        connectTimeout: 60000 as Duration,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.plain,
      ),
    );
    dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        responseHeader: true,
        requestHeader: true,
        request: true,
      ),
    );
    final response = await dio.get(request);

    if (response.statusCode == 200) {
      final result = json.decode(response.data);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}