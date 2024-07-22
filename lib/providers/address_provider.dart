import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'location_provider.dart';

final addressProvider = FutureProvider<String>((ref) async {
  final location = await ref.watch(locationProvider.future);

  final response = await http.get(Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}&addressdetails=1'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);

    if (jsonResponse['address'] != null) {
      final address = jsonResponse['address'];
      String country = address['country'] ?? 'Country not found';
      String city =
          address['city'] ?? address['town'] ?? address['village'] ?? 'City not found';

      return '$city, $country';
    } else {
      throw Exception('Address not found');
    }
  } else {
    throw Exception('Failed to load address');
  }
});
