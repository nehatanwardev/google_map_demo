// marker_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/marker_model.dart';

class MarkerProvider extends ChangeNotifier {
  GoogleMapController? mapController;
  List<Marker> markers = [];
  List<MarkerInfo> markersInfo = [];
  LatLng center = LatLng(28.4595, 77.0266);

// load marker

  Future<void> loadMarkers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? markerList = prefs.getStringList('markers');

      if (markerList != null) {
        markers = markerList.asMap().entries.map((entry) {
          int index = entry.key;
          String markerString = entry.value;

          List<String> parts = markerString.split(',');
          double latitude = double.parse(parts[0]);
          double longitude = double.parse(parts[1]);
          String label = parts[2];
          LatLng position = LatLng(latitude, longitude);

          return Marker(
            markerId:
                MarkerId('$index'), // Use the index as a unique identifier
            position: position,
            infoWindow: InfoWindow(title: label),
          );
        }).toList();

        notifyListeners();

        markersInfo = markerList.map((markerString) {
          List<String> parts = markerString.split(',');
          double latitude = double.parse(parts[0]);
          double longitude = double.parse(parts[1]);
          String label = parts[2];
          LatLng position = LatLng(latitude, longitude);

          return MarkerInfo(position: position, label: label);
        }).toList();

        notifyListeners();
      }
    } catch (e) {
      // Handle error loading markers
      print('Error loading markers: $e');
    }

    // Notify listeners about the change
    notifyListeners();
  }

  //add marker
  void addMarker(LatLng position, String label) {
    markers.add(
      Marker(
        markerId: MarkerId('${markers.length}'),
        position: position,
        infoWindow: InfoWindow(title: label),
      ),
    );
    markersInfo.add(MarkerInfo(position: position, label: label));

    // Move the camera to the tapped marker
    mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );

    center = position;

    // Notify listeners about the change
    notifyListeners();
  }

//add markers with label
  void addMarkerFromDialog(BuildContext context, LatLng location) {
    String label = 'Marker ${markers.length + 1}'; // Default label
    print("lat-long ${location}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Marker'),
          content: Column(
            children: [
              Text('Latitude: ${location.latitude}'),
              Text('Longitude: ${location.longitude}'),
              TextField(
                decoration: InputDecoration(labelText: 'Label'),
                onChanged: (value) => label = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                addMarker(location, label); // Call the provider method
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearMarkers() async {
    markers.clear();
    markersInfo.clear();

    // Remove markers from SharedPreferences
    await _clearSavedMarkers();

    notifyListeners();
  }

  Future<void> _clearSavedMarkers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('markers');
    } catch (e) {
      print('Error removing markers: $e');
    }
  }

  Future<void> saveMarkers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> markerList = markersInfo
          .map((info) =>
              '${info.position.latitude},${info.position.longitude},${info.label}')
          .toList();

      await prefs.setStringList('markers', markerList);

      notifyListeners();
    } catch (e) {
      print('Error saving markers: $e');
    }
  }

  void onCameraMove(CameraPosition position) {
    center = position.target;

    notifyListeners();
  }
}
