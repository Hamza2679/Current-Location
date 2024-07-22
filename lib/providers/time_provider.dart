import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

import 'location_provider.dart';

final timeProvider = FutureProvider<String>((ref) async {
  final location = await ref.watch(locationProvider.future);

  final latitude = location.latitude;
  final longitude = location.longitude;

  final response = await http.get(Uri.parse(
      'http://api.timezonedb.com/v2.1/get-time-zone?key=32SIP3RKM6WK&format=xml&by=position&lat=$latitude&lng=$longitude'));

  if (response.statusCode == 200) {
    final document = xml.XmlDocument.parse(response.body);
    final gmtOffset = int.parse(document.findAllElements('gmtOffset').single.text);

    DateTime utcTime = DateTime.now().toUtc();
    DateTime localTime = utcTime.add(Duration(seconds: gmtOffset));
    String formattedTime = DateFormat('hh:mm a').format(localTime);

    return formattedTime;
  } else {
    throw Exception('Failed to load time zone');
  }
});
