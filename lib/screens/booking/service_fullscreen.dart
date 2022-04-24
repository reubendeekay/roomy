import 'package:flutter/material.dart';
import 'package:roomy/constants.dart';
import 'package:roomy/models/service_model.dart';
import 'package:roomy/widgets/cached_image.dart';

class ServiceFullscreen extends StatefulWidget {
  static const routeName = '/service-fullscreen';
  final Function(bool property) onPressed;
  final ServiceModel service;
  final bool isSelected;
  ServiceFullscreen({this.onPressed, this.service, this.isSelected});

  @override
  _ServiceFullscreenState createState() => _ServiceFullscreenState();
}

class _ServiceFullscreenState extends State<ServiceFullscreen> {
  bool isTapped = false;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isTapped = !isTapped;
              });
            },
            child: Container(
              width: size.width,
              height: size.height,
              child: cachedImage(
                widget.service.imageUrl,
                height: double.infinity,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: isTapped ? -size.height * 0.5 : 0,
            child: Container(
              color: Colors.black54,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.service.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text(
                          'Price: \$${widget.service.price}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.av_timer,
                          color: Colors.grey,
                          size: 12,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.service.status,
                          style: TextStyle(fontSize: 12),
                        ),
                        Spacer(),
                        // if (isSelected)
                        AnimatedOpacity(
                          opacity: isSelected ? 1 : 0,
                          duration: Duration(milliseconds: 200),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: kPrimary,
                                size: 16,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Selected',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            bottom: isTapped ? -100 : 5,
            left: 0,
            right: 0,
            child: Container(
              width: size.width,
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    isSelected = !isSelected;
                  });
                  widget.onPressed(isSelected);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: kPrimary,
                child: Text(
                  isSelected ? 'Unselect' : 'Select',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
