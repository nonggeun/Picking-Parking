import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/components/map/map_parking_submit.dart';
import 'package:frontend/components/common/bottom_navigation_bar.dart';
import 'package:frontend/controller.dart';
import 'package:get/get.dart';

class ParkingZoneSubmitScreen extends StatefulWidget {
  const ParkingZoneSubmitScreen({super.key});
  @override
  _ParkingZoneSubmitScreenState createState() =>
      _ParkingZoneSubmitScreenState();
}

class _ParkingZoneSubmitScreenState extends State<ParkingZoneSubmitScreen> {
  final MapController _mapController = MapController();
  LatLng? currentCenter;
  bool loading = true;
  bool showParkingSubmit = false;

  @override
  void initState() {
    super.initState();
    currentCenter = LatLng(37.50125721312779, 127.03957422312601);
    getPosition();
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      setState(() {
        currentCenter = LatLng(position.latitude, position.longitude);
        _mapController.move(currentCenter!, 15.0);
      });
    } catch (e) {
      print("Error fetching current location: $e");
    }
  }

  void _onMapMove(MapPosition position, bool hasGesture) {
    setState(() {
      currentCenter = position.center;
    });
  }

  Future<void> getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      setState(() {
        currentCenter = LatLng(position.latitude, position.longitude);
        loading = false;
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void _toggleParkingSubmit() {
    setState(() {
      showParkingSubmit = !showParkingSubmit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find<MainController>();
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: '장소를 검색하세요',
            suffixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.all(8.0),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _moveToCurrentLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: showParkingSubmit ? 1 : 2,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          center: currentCenter,
                          minZoom: 10.0,
                          zoom: 15.0,
                          maxZoom: 18.0,
                          onPositionChanged: _onMapMove,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                          ),
                        ],
                      ),
                      Center(
                        child: SvgPicture.asset(
                          'assets/icons/pin_map.svg',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: FloatingActionButton(
                          onPressed: _moveToCurrentLocation,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.my_location,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          ),
          if (showParkingSubmit)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ParkingSubmit(
                  latitude: currentCenter!.latitude,
                  longitude: currentCenter!.longitude,
                  onClose: _toggleParkingSubmit,
                ),
              ),
            ),
          if (!showParkingSubmit)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _toggleParkingSubmit,
                child: const Text('등록하기'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        onTap: (int index) {
          controller.changePage(index);
        },
      ),
    );
  }
}
