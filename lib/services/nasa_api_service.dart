import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/mars_photo.dart';

class NasaApiService {
  static const String baseUrl =
      'https://rovers.nebulum.one/api/v1/rovers';

  Future<List<MarsPhoto>> getPhotosByDate({
    required String rover,
    required String date,
  }) async {
    final url = Uri.parse(
      '$baseUrl/$rover/photos?earth_date=$date',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body);

    final photos = data['photos'] as List;

    return photos.map((photo) => MarsPhoto.fromJson(photo)).toList();
  }

  Future<List<MarsPhoto>> getPhotosBySol({
    required String rover,
    required int sol,
  }) async {
    final url = Uri.parse(
      '$baseUrl/$rover/photos?sol=$sol',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body);

    final photos = data['photos'] as List;

    return photos.map((photo) => MarsPhoto.fromJson(photo)).toList();
  }
}