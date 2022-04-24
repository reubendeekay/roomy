import 'package:flutter/material.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/auth_provider.dart';
import 'package:roomy/providers/dark_mode_provider.dart';
import 'package:roomy/providers/location_provider.dart';

class BookingMapTrail extends StatefulWidget {
  final PropertyModel property;
  BookingMapTrail(this.property);
  @override
  _BookingMapTrailState createState() => _BookingMapTrailState();
}

class _BookingMapTrailState extends State<BookingMapTrail> {
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
//Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("1");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
    });
  }

  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyDxbfpRGmq3Wjex1SfTXwySuxQaCiQZxUM");

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
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData;
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _markers.addAll([
      Marker(
        markerId: MarkerId(widget.property.id),
        onTap: () {},
        icon: await MarkerIcon.downloadResizePictureCircle(
            widget.property.coverImage,
            borderSize: 10,
            size: 130,
            addBorder: true,
            borderColor: kPrimary),
        position: LatLng(widget.property.location.latitude,
            widget.property.location.longitude),
        infoWindow: InfoWindow(title: widget.property.name),
      ),
      Marker(
        markerId: MarkerId(widget.property.id),
        onTap: () {},
        icon: await MarkerIcon.downloadResizePictureCircle(user.imageUrl,
            borderSize: 10, size: 100, addBorder: true, borderColor: kPrimary),
        position: LatLng(loc.latitude, loc.longitude),
        infoWindow: InfoWindow(title: 'You'),
      ),
    ]);

    var _coordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(loc.latitude, loc.longitude),
        destination: LatLng(widget.property.location.latitude,
            widget.property.location.longitude),
        mode: RouteMode.driving);
    _addPolyline(_coordinates);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData;

    return GoogleMap(
      // myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      markers: _markers,
      polylines: _polylines.values.toSet(),
      initialCameraPosition:
          CameraPosition(target: LatLng(loc.latitude, loc.longitude), zoom: 16),
    );
  }
}
