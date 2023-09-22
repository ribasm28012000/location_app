import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String textLocation = 'Tap Find to Know Your Location';
  String lat = "";
  String lon = "";

  Position? _currentLocation;

  bool? serviceEnabled;

  bool? hadPermission;

  LocationPermission? permission;

  Future<bool> _locationPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> _handleCurrentPosition() async {
    final hasPermission = await _locationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentLocation = position);
      textLocation = "It's Your Location";
      lon = "Longitude : ";
      lat = "Latitude : ";
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    final valueLatitude = _currentLocation?.latitude;
    final valueLongitude = _currentLocation?.longitude;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOCATION APP',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                height: h * 0.10,
                child: Text(
                  textLocation,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                )),
            SizedBox(
                height: h * 0.10,
                child: Text(
                  '$lat ${valueLatitude ?? ""}',
                  style: const TextStyle(fontSize: 20),
                )),
            SizedBox(
                height: h * 0.10,
                child: Text(
                  '$lon ${valueLongitude ?? ""}',
                  style: const TextStyle(fontSize: 20),
                )),
            SizedBox(
              height: h * 0.30,
            ),
            Container(
              height: h * 0.06,
              width: w - 40,
              decoration: ShapeDecoration(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: TextButton(
                onPressed: () async {
                  serviceEnabled = await Geolocator.isLocationServiceEnabled();

                  permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    // ignore: use_build_context_synchronously
                    showModalBottomSheet(
                        isScrollControlled: false,
                        isDismissible: false,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        elevation: 50,
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            height: h * 0.50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: SvgPicture.asset(
                                        "assets/navigation_logo.svg")),
                                        SizedBox(height: h*0.05),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(15),
                                          child: const Text(
                                            'Enable your location',
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Before using this service you must enable',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          child: const Text(
                                            'location on your device.',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.05,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: w * 0.40,
                                      height: h * 0.05,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey.shade200),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'No, Thanks',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                    ),
                                    SizedBox(
                                      width: w * 0.40,
                                      height: h * 0.05,
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.blue),
                                          onPressed: () async {
                                            await _locationPermission();
                                            hadPermission =
                                                await _locationPermission();
                                            if (hadPermission!) {
                                              _handleCurrentPosition();
                                            }
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Allow',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: h * 0.07,
                                )
                              ],
                            ),
                          );
                        });
                  } else {
                    _handleCurrentPosition();
                  }
                },
                child: const Text(
                  'Find',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
          ],
        ),
      ),
    );
  }
}