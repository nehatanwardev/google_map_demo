import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerDialog extends StatelessWidget {
  Marker marker;

  MarkerDialog({super.key, required this.marker});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Marker Information'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Latitude: ${marker.position.latitude}'),
          Text('Longitude: ${marker.position.longitude}'),
          Text('Label: ${marker.infoWindow.title}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
