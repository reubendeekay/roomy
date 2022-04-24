// ignore_for_file: prefer_null_aware_operators

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/constants.dart';

import 'package:roomy/admin/providers/admin_property_provider.dart';
import 'package:roomy/admin/screens/add_property/add_ammenities.dart';
import 'package:roomy/admin/screens/add_property/add_on_map.dart';
import 'package:roomy/admin/screens/add_property/add_service.dart';
import 'package:roomy/admin/widgets/my_dropdown.dart';
import 'package:roomy/models/property_model.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/models/view360_model.dart';
import 'package:roomy/providers/location_provider.dart';
import 'package:roomy/widgets/cached_image.dart';

class EditPropertyScreen extends StatefulWidget {
  static const routeName = '/edit-property';
  @override
  _EditPropertyScreenState createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  PropertyModel property;
  File coverFile;
  List<File> fileImages = [];
  List<File> view360Images = [];
  String name;
  String coverImage;
  String description;
  String price;
  String category;
  String rate;
  List<String> images;
  String town;
  String tags = '';

  String country;
  double longitude;
  double latitude;
  List<String> ammenities = [];
  List<Media> mediaList = [];
  List<ServiceModel> services = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locData = Provider.of<LocationProvider>(context);
    final PropertyModel property = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        title: const Text('Edit Travely',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
//COVER IMAGE
            GestureDetector(
              onTap: () async => openImagePicker(context, true),
              child: Container(
                height: size.width * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: coverFile == null
                    ? Stack(
                        children: [
                          cachedImage(
                            property.coverImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add_a_photo,
                                    size: 24, color: Colors.white),
                                SizedBox(height: 10),
                                Text(
                                  'Select the cover image',
                                  style:
                                      TextStyle(color: Colors.white, shadows: [
                                    Shadow(
                                      blurRadius: 2,
                                      color: Colors.grey,
                                      offset: Offset(1, 1),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Image.file(
                        coverFile,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            //PROPERTY NAME
            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter the name of the travely';
                    }

                    return null;
                  },
                  initialValue: property.name,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    labelText: 'Name of travely',
                    helperStyle: const TextStyle(color: kPrimary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: kPrimary, width: 1)),
                  ),
                  onChanged: (text) => {
                        setState(() {
                          name = text;
                        })
                      }),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                  maxLines: null,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter the description';
                    }

                    return null;
                  },
                  maxLength: null,
                  initialValue: property.description,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    labelText: 'Detailed description',
                    helperStyle: const TextStyle(color: kPrimary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: kPrimary, width: 1)),
                  ),
                  onChanged: (text) => {
                        setState(() {
                          description = text;
                        })
                      }),
            ),
            MyDropDown(
              selectedOption: (val) {
                setState(() {
                  rate = val;
                });
              },
              options: rates,
              hintText: 'Change the rates',
            ),
            MyDropDown(
              hintText: 'Change the category',
              options: categories,
              selectedOption: (val) {
                setState(() {
                  category = val;
                });
              },
            ),

            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                  maxLines: null,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (double.parse(val) < 1) {
                      return 'Please enter a valid price';
                    }

                    return null;
                  },
                  initialValue: property.price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    labelText: 'Average Price in USD (\$)',
                    helperStyle: const TextStyle(color: kPrimary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: kPrimary, width: 1)),
                  ),
                  onChanged: (text) => {
                        setState(() {
                          price = text;
                        })
                      }),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                  maxLines: null,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter the town/city';
                    }

                    return null;
                  },
                  initialValue: property.location.town,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    labelText: 'Town/City',
                    helperStyle: const TextStyle(color: kPrimary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: kPrimary, width: 1)),
                  ),
                  onChanged: (text) => {
                        setState(() {
                          town = text;
                        })
                      }),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                  maxLines: null,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Please enter the country';
                    }

                    return null;
                  },
                  initialValue: property.location.country,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    labelText: 'Country',
                    helperStyle: const TextStyle(color: kPrimary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: kPrimary, width: 1)),
                  ),
                  onChanged: (text) => {
                        setState(() {
                          country = text;
                        })
                      }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                'Key Features',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            GestureDetector(
              onTap: () {
                Get.to(() => AddAmmenities(
                      onComplete: (val) {
                        setState(() {
                          ammenities = val;
                        });
                      },
                    ));
              },
              child: Container(
                  height: 48,
                  width: size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ammenities.isEmpty
                        ? property.ammenities.join(',')
                        : '${ammenities.length} feature(s)',
                    style: TextStyle(color: Colors.grey[800], fontSize: 15),
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                'Detailed services',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => AddServices(
                      onCompleted: (val) {
                        setState(() {
                          services = val;
                        });
                      },
                    ));
              },
              child: Container(
                  height: 48,
                  width: size.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    services.isEmpty
                        ? property.services
                            .map((e) => e.name)
                            .toList()
                            .join(',')
                        : '${services.length} service(s)',
                    style: TextStyle(color: Colors.grey[800], fontSize: 15),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                'Separate each tag with a comma',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: TextFormField(
                  maxLines: null,
                  initialValue:
                      property.tags != null ? property.tags.join(',') : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    labelText: 'Tags',
                    helperStyle: const TextStyle(color: kPrimary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: kPrimary, width: 1)),
                  ),
                  onChanged: (text) => {
                        setState(() {
                          tags = text;
                        })
                      }),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                'Location on the map',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Text(
                    locData.longitude != null && locData.latitude != null
                        ? 'Selected at (${locData.latitude.toStringAsFixed(2)}, ${locData.longitude.toStringAsFixed(2)})'
                        : 'Selected at (${property.location.latitude.toStringAsFixed(2)}, ${property.location.longitude.toStringAsFixed(2)})',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: locData.longitude != null &&
                                locData.latitude != null
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: locData.longitude != null &&
                                locData.latitude != null
                            ? Colors.green
                            : Colors.black),
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () => Navigator.of(context)
                              .pushNamed(AddOnMap.routeName, arguments: {
                            'lat': latitude,
                            'lon': longitude,
                          }),
                      child: const Icon(Icons.map))
                ],
              ),
            ),
            const Divider(),

            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: const Text(
                'Add more photos',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),

            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () async => await openImagePicker(context, false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Column(
                          children: const [
                            Icon(Icons.add),
                            Text(
                              'Photos',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (fileImages != null)
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          children: [
                            ...List.generate(
                              property.images.length,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                height: 120,
                                width: 130,
                                child: cachedImage(
                                  property.images[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            ...List.generate(
                              fileImages.length,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                height: 120,
                                width: 130,
                                child: Image.file(
                                  fileImages[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                )),
            const SizedBox(
              height: 15,
            ),

            Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: const Text(
                '360 Viewing Experience',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      openImagePicker(context, false, is360: 'yes');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                      margin: const EdgeInsets.only(top: 15),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        children: const [
                          Icon(Icons.add),
                          Text(
                            '360 View',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ),
                  if (view360Images != null)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Row(
                        children: List.generate(
                          view360Images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 120,
                            width: 130,
                            child: Image.file(
                              view360Images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              width: size.width * 0.8,
              height: 45,
              child: RaisedButton(
                color: kPrimary,
                onPressed: () async {
                  final uploadProperty = PropertyModel(
                    ammenities: ammenities.isNotEmpty
                        ? ammenities
                        : property.ammenities,
                    id: property.id,
                    panoramicView: view360Images
                        .map((e) => View360Model(image: e))
                        .toList(),
                    services: services,
                    rates: rate ?? property.rates,
                    tags: tags.toLowerCase().split(','),
                    coverImage: coverImage,
                    coverFile: property.coverFile,
                    imageFiles: fileImages,
                    description: description ?? property.description,
                    images: property.images,
                    name: name ?? property.name,
                    price: price ?? property.price,
                    propertyCategory: category ?? property.propertyCategory,
                    location: PropertyLocation(
                      latitude: locData.latitude ?? property.location.latitude,
                      longitude:
                          locData.longitude ?? property.location.longitude,
                      country: country ?? property.location.country,
                      town: town ?? property.location.town,
                    ),
                  );
                  await Provider.of<AdminPropertyProvider>(context,
                          listen: false)
                      .editProperty(uploadProperty);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'Preview',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  List<String> categories = [
    'Activity',
    'Hotel',
    'Restaurant',
    'Residence',
    'Event',
    'Flight',
    'Transport',
    'Shopping',
  ];
  List<String> rates = [
    'Per table',
    'Per person',
    'Per hour',
    'Per day',
    'Per night',
    'Per week',
    'Per month',
    'Per year',
  ];

  Future<void> openImagePicker(BuildContext context, bool isCover,
      {String is360}) async {
    // openCamera(onCapture: (image){
    //   setState(()=> mediaList = [image]);
    // });
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.95,
                minChildSize: 0.6,
                builder: (ctx, controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    child: MediaPicker(
                      scrollController: controller,
                      mediaList: mediaList,
                      onPick: (selectedList) {
                        setState(() => mediaList = selectedList);
                        if (is360 != null) {
                          for (var element in mediaList) {
                            view360Images.add(element.file);
                          }
                          mediaList.clear();
                        }
                        if (isCover) {
                          coverFile = mediaList.first.file;
                          mediaList.clear();
                        } else {
                          for (var element in mediaList) {
                            fileImages.add(element.file);
                          }
                          mediaList.clear();
                        }

                        mediaList.clear();

                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount:
                          isCover ? MediaCount.single : MediaCount.multiple,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeText: 'Change',
                      ),
                    )),
              ));
        });
  }

  void openMap(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.8,
                maxChildSize: 0.95,
                minChildSize: 0.8,
                builder: (ctx, controller) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  color: Colors.white,
                  child: AddOnMap(),
                ),
              ));
        });
  }
}
