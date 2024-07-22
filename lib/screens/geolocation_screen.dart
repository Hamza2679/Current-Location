import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/location_provider.dart';
import '../providers/address_provider.dart';
import '../providers/time_provider.dart';
import '../widgets/information_button.dart';


class GeolocationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsyncValue = ref.watch(locationProvider);
    final addressAsyncValue = ref.watch(addressProvider);
    final timeAsyncValue = ref.watch(timeProvider);

    Future<void> _checkPermissions() async {
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      } else {
        // The user denied the permission or it is permanently denied.
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Geolocation Screen'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _checkPermissions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return locationAsyncValue.when(
                data: (location) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Location Coordinates',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Latitude: ${location.latitude}, Longitude: ${location.longitude}',
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Location Address',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      addressAsyncValue.when(
                        data: (address) => Text(address),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) => Text('Error: $error'),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Location Time',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      timeAsyncValue.when(
                        data: (time) => Text(time),
                        loading: () => const CircularProgressIndicator(),
                        error: (error, stackTrace) => Text('Error: $error'),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        height: 200,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: location,
                            zoom: 14,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              position: location,
                            ),
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      InformationButton(onPressed: () {}),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Text('Error: $error'),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
