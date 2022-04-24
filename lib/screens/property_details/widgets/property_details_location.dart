import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/dark_mode_provider.dart';

class PropertyDetailsLocation extends StatefulWidget {
  final PropertyModel property;
  PropertyDetailsLocation(this.property);
  @override
  _PropertyDetailsLocationState createState() =>
      _PropertyDetailsLocationState();
}

class _PropertyDetailsLocationState extends State<PropertyDetailsLocation> {
  GoogleMapController mapController;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    bool isDark =
        Provider.of<DarkThemeProvider>(context, listen: false).darkTheme;
    mapController = controller;
    String value = isDark
        ? await DefaultAssetBundle.of(context)
            .loadString('assets/map_dark.json')
        : await DefaultAssetBundle.of(context)
            .loadString('assets/map_style.json');
    mapController.setMapStyle(value);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(widget.property.id),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position: widget.property.location.latitude == null
              ? LatLng(-3.2406865930924504, 40.12467909604311)
              : LatLng(widget.property.location.latitude,
                  widget.property.location.longitude),
          infoWindow: InfoWindow(title: widget.property.name),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Location',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey[300],
                  width: 1,
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GoogleMap(
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                markers: _markers,
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.property.location.latitude,
                        widget.property.location.longitude),
                    zoom: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
