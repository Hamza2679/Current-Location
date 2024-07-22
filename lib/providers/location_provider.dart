import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final locationProvider = FutureProvider<LatLng>((ref) async {
  final response = await http.get(Uri.parse('https://ipinfo.io/json'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final loc = jsonResponse['loc'].split(',');
    return LatLng(double.parse(loc[0]), double.parse(loc[1]));
  } else {
    throw Exception('Failed to load location');
  }
});
