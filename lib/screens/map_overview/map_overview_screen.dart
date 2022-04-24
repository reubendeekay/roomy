import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/providers/dark_mode_provider.dart';
import 'package:roomy/providers/location_provider.dart';
import 'package:roomy/providers/property_provider.dart';
import 'package:roomy/screens/home/view_all_card.dart';

class MapOverviewScreen extends StatefulWidget {
  @override
  _MapOverviewScreenState createState() => _MapOverviewScreenState();
}

class _MapOverviewScreenState extends State<MapOverviewScreen> {
  PropertyModel selectedProperty;

  GoogleMapController mapController;
  Set<Marker> _markers = {};
  BitmapDescriptor _markerIcon;

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
    final properties =
        Provider.of<PropertyProvider>(context, listen: false).properties;

    _markers.addAll([
      for (final property in properties)
        await Marker(
          markerId: MarkerId(property.id),
          onTap: () {
            setState(() {
              selectedProperty = property;
            });
          },
          icon: await MarkerIcon.downloadResizePictureCircle(
              property.coverImage,
              borderSize: 10,
              size: 130,
              addBorder: true,
              borderColor: kPrimary),
          position:
              LatLng(property.location.latitude, property.location.longitude),
          infoWindow: InfoWindow(title: property.name),
        ),
    ]);

    setState(() {});
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setCustomMarker();
    });

    super.initState();
  }

  void setCustomMarker() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          size: Size(3, 3),
        ),
        'assets/images/marker.png',
        mipmaps: false);
  }

  final mapSearchController = TextEditingController();
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var _locationData =
        Provider.of<LocationProvider>(context, listen: false).locationData;
    LatLng _initialPosition =
        LatLng(_locationData.latitude, _locationData.longitude);

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ///////////////////////HEADER ABOVE ////////////////////////////
          Container(
            margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: Card(
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                controller: mapSearchController,
                onSubmitted: (value) async {
                  final prop = await searchProperty(value);
                  setState(() {
                    selectedProperty = prop != null ? prop : selectedProperty;
                  });
                  if (selectedProperty != null)
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            selectedProperty.location.latitude,
                            selectedProperty.location.longitude,
                          ),
                          zoom: 12,
                        ),
                      ),
                    );
                },
                style: TextStyle(color: Colors.black),
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: -5,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 22,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  hintText: 'Search name or destination',
                  hintStyle: GoogleFonts.openSans(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          if (selectedProperty != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  ViewAllCard(selectedProperty),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: kPrimary,
                        ),
                        tooltip: 'Remove',
                        onPressed: () {
                          setState(() {
                            selectedProperty = null;
                          });
                        },
                      ))
                ],
              ),
            ),
          //////////////////GOOGLE MAP/////////////////
          Expanded(
            child: Stack(
              children: [
                // MyMarker(globalKey),
                GoogleMap(
                  onTap: (value) {
                    print(value);
                  },
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  markers: _markers,
                  onMapCreated: _onMapCreated,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: _initialPosition, zoom: 12),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Future<PropertyModel> searchProperty(String value) async {
    final propertyData = await FirebaseFirestore.instance
        .collection('propertyData')
        .doc('propertyListing')
        .collection('properties')
        .get();
    List<PropertyModel> propData = [];

    propertyData.docs
        .where((element) =>
            element['name'].toLowerCase().contains(value.toLowerCase()) ||
            element['location']['town']
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            element['propertyCategory']
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            element['location']['country']
                .toLowerCase()
                .contains(value.toLowerCase()))
        .forEach((e) {
      propData.add(PropertyModel(
        id: e.id,
        name: e['name'],
        coverImage: e['coverImage'],
        ammenities: e['ammenities'],
        price: e['price'],
        rating: double.parse(e['rating'].toString()),
        rates: e['rates'],
        views: e['views'],
        location: PropertyLocation(
          country: e['location']['country'],
          latitude: e['location']['latitude'],
          longitude: e['location']['longitude'],
          town: e['location']['town'],
        ),
        images: e['images'],
        reviews: e['reviews'],
        ownerId: e['ownerId'],
        propertyOwner: e['ownerName'],
        propertyCategory: e['propertyCategory'],
        description: e['description'],
        offers: e['offers'],
      ));
    });

    return propData.first;
  }
}
