import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:frontend/controller.dart';
import 'package:frontend/components/map/map_reservation_submit.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final MainController controller = Get.put(MainController());
  final MapController _mapController = MapController();
  LatLng? currentCenter;
  bool loading = true;
  int? selectedIndex;
  bool showReservationSubmit = false;
  String searchText = '';

  final List<Map<String, dynamic>> dummyData = [
    {
      "longitude": 127.039574,
      "latitude": 37.501257,
      "parking_zone_name": "역삼 멀티캠퍼스",
      "fee": 2000,
      "time": [
        {"start": "2024-11-10T06:00:00", "end": "2024-11-10T09:00:00"},
        {"start": "2024-11-10T10:00:00", "end": "2024-11-10T23:59:59"},
        {"start": "2024-11-11T00:00:00", "end": "2024-11-11T23:59:59"},
        {"start": "2024-11-12T00:00:00", "end": "2024-11-12T08:00:00"},
        {"start": "2024-11-12T10:00:00", "end": "2024-11-12T12:00:00"},
        {"start": "2024-11-12T14:00:00", "end": "2024-11-12T23:59:59"},
      ]
    },
    {
      "longitude": 127.040000,
      "latitude": 37.502000,
      "parking_zone_name": "강남 주차장",
      "fee": 3000,
      "time": [
        {"start": "2024-11-10T06:00:00", "end": "2024-11-10T09:00:00"},
        {"start": "2024-11-10T10:00:00", "end": "2024-11-10T23:59:59"}
      ]
    },
    {
      "longitude": 127.041000,
      "latitude": 37.503000,
      "parking_zone_name": "멀티캠퍼스 주차장",
      "fee": 4000,
      "time": [
        {"start": "2024-11-10T06:00:00", "end": "2024-11-10T09:00:00"},
        {"start": "2024-11-10T10:00:00", "end": "2024-11-10T23:59:59"}
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    currentCenter = LatLng(37.501257, 127.039574);
    getPosition();
  }

  Future<void> getPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentCenter = LatLng(position.latitude, position.longitude);
      currentCenter = LatLng(37.501257, 127.039574);
      loading = false;
    });
  }

  void _moveToLocation(double lat, double lng) {
    setState(() {
      currentCenter = LatLng(lat, lng);
      _mapController.move(currentCenter!, 15.0);
    });
  }

  void _moveToCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentCenter = LatLng(position.latitude, position.longitude);
      _mapController.move(currentCenter!, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredData = dummyData.where((data) {
      return data['parking_zone_name']
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: '주차 구역 검색',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          if (searchText.isNotEmpty)
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in filteredData)
                    ListTile(
                      title: Text(item['parking_zone_name']),
                      onTap: () {
                        selectedIndex = dummyData.indexWhere((data) =>
                            data['parking_zone_name'] ==
                            item['parking_zone_name']);
                        showReservationSubmit = true;
                        _moveToLocation(item['latitude'], item['longitude']);
                        setState(() {
                          searchText = '';
                        });
                      },
                    ),
                ],
              ),
            ),
          Expanded(
            flex: showReservationSubmit ? 1 : 2,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: currentCenter,
                          maxZoom: 18.0,
                          zoom: 15.0,
                          minZoom: 10.0,
                          interactiveFlags:
                              InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: showReservationSubmit &&
                                    selectedIndex != null
                                ? [
                                    Marker(
                                      point: LatLng(
                                        dummyData[selectedIndex!]['latitude'],
                                        dummyData[selectedIndex!]['longitude'],
                                      ),
                                      builder: (ctx) => Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showReservationSubmit = false;
                                                selectedIndex = null;
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/icons/pin_map.svg',
                                              height: 40,
                                              width: 40,
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 30,
                                            child: Container(
                                              padding: EdgeInsets.all(0),
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              child: Text(
                                                dummyData[selectedIndex!]
                                                    ['parking_zone_name'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                                : dummyData.map((data) {
                                    LatLng location = LatLng(
                                        data['latitude'], data['longitude']);
                                    int markerIndex = dummyData.indexOf(data);
                                    return Marker(
                                      point: location,
                                      builder: (ctx) => Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            bottom: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (selectedIndex ==
                                                          markerIndex &&
                                                      showReservationSubmit) {
                                                    showReservationSubmit =
                                                        false;
                                                    selectedIndex = null;
                                                  } else {
                                                    selectedIndex = markerIndex;
                                                    showReservationSubmit =
                                                        true;
                                                  }
                                                });
                                              },
                                              child: SvgPicture.asset(
                                                'assets/icons/pin_map.svg',
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 30,
                                            child: Container(
                                              padding: EdgeInsets.all(0),
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              child: Text(
                                                data['parking_zone_name'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          onPressed: _moveToCurrentLocation,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.my_location,
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    ],
                  ),
          ),
          if (showReservationSubmit && selectedIndex != null)
            Expanded(
              flex: 2,
              child: ReservationSubmit(
                latitude: dummyData[selectedIndex!]['latitude'],
                longitude: dummyData[selectedIndex!]['longitude'],
                parkingZoneName: dummyData[selectedIndex!]['parking_zone_name'],
                timeSlots: dummyData[selectedIndex!]['time'],
                fee: dummyData[selectedIndex!]['fee'],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (index) {
          controller.changePage(index);
        },
      ),
    );
  }
}
