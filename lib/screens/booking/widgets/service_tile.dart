import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/providers/booking_provider.dart';
import 'package:roomy/screens/booking/service_fullscreen.dart';
import 'package:roomy/widgets/cached_image.dart';

class SelectableServiceTile extends StatefulWidget {
  final ServiceModel service;
  SelectableServiceTile(this.service);
  @override
  _SelectableServiceTileState createState() => _SelectableServiceTileState();
}

class _SelectableServiceTileState extends State<SelectableServiceTile> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        Provider.of<BookingProvider>(context, listen: false)
            .addService(widget.service);
      },
      onLongPress: () {
        Get.to(() => ServiceFullscreen(
              isSelected: isSelected,
              service: widget.service,
              onPressed: (val) {
                setState(() {
                  isSelected = val;
                });
                Provider.of<BookingProvider>(context, listen: false)
                    .addService(widget.service);
              },
            ));
      },
      child: Container(
        width: double.infinity,
        height: size.height * 0.1,
        constraints: BoxConstraints(minHeight: 70),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: Container(
                        child: Row(
                  children: [
                    Container(
                      width: size.width * 0.25,
                      child: cachedImage(
                        widget.service.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            widget.service.name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.av_timer,
                              size: 12,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.service.status,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        Container(
                          child: Text(
                            'KES ${widget.service.price.toStringAsFixed(2)}',
                            style: TextStyle(color: kPrimary),
                          ),
                        ),
                      ],
                    ))
                  ],
                ))),
                Divider()
              ],
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: size.height * 0.1,
                width: size.width,
                color: kPrimary.withOpacity(0.2),
              ),
          ],
        ),
      ),
    );
  }
}

class ServiceTile extends StatefulWidget {
  final ServiceModel service;
  ServiceTile(this.service);
  @override
  _ServiceTileState createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => ServiceFullscreen(
              isSelected: isSelected,
              service: widget.service,
              onPressed: (val) {
                setState(() {
                  isSelected = val;
                });
                Provider.of<BookingProvider>(context, listen: false)
                    .addService(widget.service);
              },
            ));
      },
      child: Container(
        width: double.infinity,
        height: size.height * 0.1,
        constraints: BoxConstraints(minHeight: 70),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: Container(
                        child: Row(
                  children: [
                    Container(
                      width: size.width * 0.25,
                      child: cachedImage(
                        widget.service.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            widget.service.name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.av_timer,
                              size: 12,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.service.status,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        Container(
                          child: Text(
                            'KES ${widget.service.price.toStringAsFixed(2)}',
                            style: TextStyle(color: kPrimary),
                          ),
                        ),
                      ],
                    ))
                  ],
                ))),
                Divider()
              ],
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: size.height * 0.1,
                width: size.width,
                color: kPrimary.withOpacity(0.2),
              ),
          ],
        ),
      ),
    );
  }
}
