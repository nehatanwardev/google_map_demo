// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controller/map_controller.dart';
import '../widgets/marker_dialog.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MarkerProvider(),
      child: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Load markers when the widget is initialized
    Provider.of<MarkerProvider>(context, listen: false).loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    var mapProvider = Provider.of<MarkerProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Map Integration')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MarkerProvider>(
              builder: (context, markerProvider, _) {
                print("markerList${markerProvider.markers}");

                return GoogleMap(
                  onMapCreated: (controller) {
                    markerProvider.mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: markerProvider.center,
                    zoom: 14.0,
                  ),
                  onTap: (location) {
                    markerProvider.addMarkerFromDialog(
                        context, location); // Call the new method
                  },
                  markers: Set.from(markerProvider.markers.map((marker) {
                    return marker.onTap != null
                        ? marker
                        : marker.copyWith(
                            onTapParam: () {
                              // Show a popup with marker information
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return MarkerDialog(marker: marker);
                                },
                              );
                            },
                          );
                  })),
                  onCameraMove: markerProvider.onCameraMove,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Consumer<MarkerProvider>(
              builder: (context, markerProvider, _) {
                return Text(
                    'Center: ${markerProvider.center.latitude}, ${markerProvider.center.longitude}');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      //remove markers----------------
                      mapProvider.clearMarkers();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Markers removed successfully')),
                      );
                    },
                    child: Text('Remove Markers'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      //saving markers-------------------

                      if (mapProvider.markers.isNotEmpty) {
                        mapProvider.saveMarkers();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Markers saved successfully')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Add Marker first')));
                      }
                    },
                    child: Text('Save Markers'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
