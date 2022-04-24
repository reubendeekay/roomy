import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:roomy/admin/constants.dart';

import 'package:roomy/admin/widgets/my_dropdown.dart';
import 'package:roomy/models/ad_model.dart';
import 'package:roomy/providers/ads_provider.dart';

class AddAdScreen extends StatefulWidget {
  static const routeName = '/add-ad';

  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final _formKey = GlobalKey<FormState>();
  File imageFile;
  List<Media> mediaList = [];
  String target;
  String description;
  String adType;
  String category;
  String numberOfPeople;
  String clickUrl;
  String targetCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimary,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Create Promo Campaign',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          automaticallyImplyLeading: false,
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: const Text(
                      'Add an image',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => openImagePicker(context),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor),
                          child: const Icon(
                            Icons.add,
                            color: Colors.grey,
                            size: 24,
                          ),
                        ),
                      ),
                      if (imageFile != null)
                        Expanded(
                            child: SizedBox(
                          height: 70,
                          child: AspectRatio(
                            aspectRatio: 5,
                            child: Image.file(
                              imageFile,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  MyDropDown(
                      options: adTypes,
                      hintText: 'Type of Ad',
                      selectedOption: (val) {
                        setState(() {
                          adType = val;
                        });
                      }),
                  MyDropDown(
                      hintText: 'Conversion type',
                      options: conversions,
                      selectedOption: (val) {
                        setState(
                          () {
                            target = val;
                          },
                        );
                      }),
                  MyDropDown(
                      hintText: 'Number of people',
                      options: numberOfPeopleList,
                      selectedOption: (val) {
                        setState(
                          () {
                            numberOfPeople = val;
                          },
                        );
                      }),
                  MyDropDown(
                      hintText: 'Target Country',
                      options: targetCountryList,
                      selectedOption: (val) {
                        setState(
                          () {
                            targetCountry = val;
                          },
                        );
                      }),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor),
                    child: TextFormField(
                        maxLines: null,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Please enter the description';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintText: 'Short desciption*',
                            hintStyle: const TextStyle(fontSize: 15),
                            helperStyle: const TextStyle(color: kPrimary),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: kPrimary, width: 1)),
                            border: InputBorder.none),
                        onChanged: (text) => {
                              setState(() {
                                description = text;
                              })
                            }),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor),
                    child: TextFormField(
                        maxLines: null,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            hintText: 'Click url',
                            hintStyle: const TextStyle(fontSize: 15),
                            helperStyle: const TextStyle(color: kPrimary),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: kPrimary, width: 1)),
                            border: InputBorder.none),
                        onChanged: (text) => {
                              setState(() {
                                clickUrl = text;
                              })
                            }),
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: RaisedButton(
                      color: kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Proceed',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await Provider.of<AdsProvider>(context, listen: false)
                              .publishAd(AdModel(
                            adType: adType,
                            country: targetCountry,
                            description: description,
                            clickUrl: clickUrl,
                            conversion: target,
                            category: category,
                            imageFile: imageFile,
                          ));

                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )));
  }

  Future<void> openImagePicker(
    BuildContext context,
  ) async {
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

                        imageFile = mediaList.first.file;
                        mediaList.clear();

                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount: MediaCount.single,
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
}

List<String> conversions = [
  'Profile',
  'Category',
  'Specific Property',
  'Only Display',
  'Search',
];

List<String> adTypes = [
  'Banner',
  'Full Screen',
  'Half Screen',
];
List<String> numberOfPeopleList = [
  '100',
  '500',
  '1000',
  '5000',
  '10000',
  '20000',
  '50000',
  '100000',
  '1000000',
  '10000000+',
];
List<String> targetCountryList = [
  'Kenya',
  'Uganda',
  'Tanzania',
  'Rwanda',
  'Burundi',
  'DRC',
  'Sudan',
  'South Sudan',
  'Somalia',
  'Ethiopia',
];
