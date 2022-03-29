import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geforcedom/screen/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageLocation extends StatefulWidget {
  @override
  State<PageLocation> createState() => _PageLocationState();
}

class _PageLocationState extends State<PageLocation> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  // Set<Marker> _markers = {};

  final List<Map<String, dynamic>> clityList = const [
    {
      "address": "Sriracha",
      "id": "Sriracha_01",
      "lat": 13.12394,
      "lng": 100.91542,
      "name": "Kensington",
    },
    {
      "address": "Sriracha",
      "id": "Sriracha_02",
      "lat": 13.12442,
      "lng": 100.91636,
      "name": "Notting Hill Laemchabang",
    },
    {
      "address": "Sriracha",
      "id": "Sriracha_03",
      "lat": 13.12349,
      "lng": 100.92763,
      "name": "Chambery",
    },
    {
      "address": "Sriracha",
      "id": "Sriracha_04",
      "lat": 13.11225,
      "lng": 100.92725,
      "name": "Grand Marina Resident",
    },
    {
      "address": "Sriracha",
      "id": "Sriracha_05",
      "lat": 13.11340,
      "lng": 100.91990,
      "name": "Groovy Sriracha",
    },
    {
      "address": "Sriracha",
      "id": "Sriracha_06",
      "lat": 13.11081,
      "lng": 100.92525,
      "name": "Saowaphan Residence",
    },
  ];

  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _markers.clear();
    setState(() {
      for (int i = 0; i < clityList.length; i++) {
        print("For Loop");
        final marker = Marker(
          markerId: MarkerId(clityList[i]['name']),
          position: LatLng(clityList[i]['lat'], clityList[i]['lng']),
          infoWindow: InfoWindow(
              title: clityList[i]['name'],
              snippet: clityList[i]['address'],
              onTap: () {
                print("${clityList[i]['lat']}, ${clityList[i]['lng']}");
              }),
          onTap: () {
            print("Clicked on marker");
          },
        );
        print("${clityList[i]['lat']}, ${clityList[i]['lng']}");
        _markers[clityList[i]['name']] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'Search by place'),
                onChanged: (value) {
                  print(value);
                },
              )),
              IconButton(
                  onPressed: () async {
                    var place = await LocationService()
                        .getPlace(_searchController.text);
                    _gotoPlace(place);
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(clityList[0]['lat'], clityList[0]['lng']),
                zoom: 15,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _gotoPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }
}
