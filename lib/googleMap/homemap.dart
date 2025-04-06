import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Homemap extends StatefulWidget {
  const Homemap({super.key});

  @override
  State<Homemap> createState() => _HomemapState();
}

BitmapDescriptor? _warningIcon;

class _Debouncer {
  final int milliseconds;
  Timer? _timer;

  _Debouncer({this.milliseconds = 500});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

const String googleMapsApiKey = 'AIzaSyB5Mwun4zFCtmZ1Ab_XpU2TnHVlPVzSHOw';

class CrimeInfoCard extends StatelessWidget {
  final Map<String, dynamic> crimeInfo;

  const CrimeInfoCard({Key? key, required this.crimeInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // Fixed width for the card
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              crimeInfo['image'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.warning_amber,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
            ),
          ),
          SizedBox(height: 10),

          // Crime type badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              crimeInfo['type'],
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(height: 8),

          // Description
          Text(
            crimeInfo['description'],
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
          SizedBox(height: 8),

          // Reports count
          Row(
            children: [
              Icon(Icons.report_problem, size: 16, color: Colors.orange),
              SizedBox(width: 4),
              Text(
                crimeInfo['reports'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Safety tips
          Text(
            'Safety Tips:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            '• Avoid at night • Stay in groups • Share location',
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _HomemapState extends State<Homemap> {
  final Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePLex = const CameraPosition(
    target: LatLng(25.4297089, 81.7728296),
    zoom: 16.4746,
  );

  final List<Marker> _markers = [];
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  bool _isLoading = false;
  bool _isNavigating = false;
  List<dynamic> _startSuggestions = [];
  List<dynamic> _destinationSuggestions = [];
  FocusNode _startFocusNode = FocusNode();
  FocusNode _destinationFocusNode = FocusNode();
  Set<Polyline> _polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  final _debouncer = _Debouncer();
  Timer? _navigationTimer;
  Position? _currentPosition;
  int _routeIndex = 0;
  List<LatLng> _routeCoordinates = [];
  double _distanceRemaining = 0;
  double _timeRemaining = 0;

  //-------------------------------extra-------------

  Future<void> _loadCustomMarker() async {
    _warningIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/warning.png', // Add this image to your assets
    );
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'] ?? 'Unknown Location';
        }
        return 'No address found';
      } else {
        print('Geocoding API error: ${response.statusCode}');
        return 'Address lookup failed';
      }
    } catch (e) {
      print('Error in getAddressFromLatLng: $e');
      return 'Error fetching address';
    }
  }

  Future<Position> getlocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, show error and return
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
          backgroundColor: Colors.red,
        ),
      );
      return Future.error('Location services are disabled');
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied'),
            backgroundColor: Colors.red,
          ),
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied. Please enable them in app settings.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get the current position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return Future.error('Error getting location: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadCurrentLocation();
    _startFocusNode.addListener(_onStartFocusChange);
    _destinationFocusNode.addListener(_onDestinationFocusChange);
    _loadCustomMarker();

    // Add heatspots near the default location
    final defaultLocation = LatLng(
      25.4297089,
      81.7728296,
    ); // Your _kGooglePLex location
    final heatSpots = _generateHeatSpots(
      defaultLocation,
      10,
      500,
    ); // 10 spots within 500m
    _markers.addAll(heatSpots);
  }

  @override
  void dispose() {
    _stopNavigation();
    _startFocusNode.removeListener(_onStartFocusChange);
    _destinationFocusNode.removeListener(_onDestinationFocusChange);
    _startFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  //extras---------------------------------------------------------------
  void _selectStartSuggestion(Map<String, dynamic> suggestion) async {
    _startController.text = suggestion['description'];
    setState(() {
      _startSuggestions = [];
      _startFocusNode.unfocus();
    });

    try {
      final placeId = suggestion['place_id'];
      final latLng = await getPlaceDetails(placeId);

      _markers.removeWhere((marker) => marker.markerId.value == 'start');

      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: latLng,
          infoWindow: InfoWindow(title: suggestion['description']),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );

      if (_destinationController.text.isNotEmpty) {
        handleSearch();
      } else {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(latLng));
        setState(() {});
      }
    } catch (e) {
      print('Error selecting start suggestion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select location'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _selectDestinationSuggestion(Map<String, dynamic> suggestion) async {
    _destinationController.text = suggestion['description'];
    setState(() {
      _destinationSuggestions = [];
      _destinationFocusNode.unfocus();
    });

    try {
      final placeId = suggestion['place_id'];
      final latLng = await getPlaceDetails(placeId);

      _markers.removeWhere((marker) => marker.markerId.value == 'destination');

      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: latLng,
          infoWindow: InfoWindow(title: suggestion['description']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      if (_startController.text.isNotEmpty) {
        handleSearch();
      } else {
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(latLng));
        setState(() {});
      }
    } catch (e) {
      print('Error selecting destination suggestion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select location'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<dynamic>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleMapsApiKey&components=country:in',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['predictions'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  Future<LatLng> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapsApiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
      throw Exception('Failed to get place details');
    } catch (e) {
      print('Error getting place details: $e');
      throw Exception('Failed to get place details: $e');
    }
  }

  void _handleStartInputChange(String value) async {
    if (value.isEmpty) {
      setState(() {
        _startSuggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await searchPlaces(value);
      setState(() {
        _startSuggestions = suggestions;
      });
    } catch (e) {
      print('Error handling start input: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching suggestions'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleDestinationInputChange(String value) async {
    if (value.isEmpty) {
      setState(() {
        _destinationSuggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await searchPlaces(value);
      setState(() {
        _destinationSuggestions = suggestions;
      });
    } catch (e) {
      print('Error handling destination input: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching suggestions'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onStartFocusChange() {
    if (_startFocusNode.hasFocus && _startController.text.isNotEmpty) {
      _handleStartInputChange(_startController.text);
    }
  }

  void _onDestinationFocusChange() {
    if (_destinationFocusNode.hasFocus &&
        _destinationController.text.isNotEmpty) {
      _handleDestinationInputChange(_destinationController.text);
    }
  }

  void _stopNavigation() {
    _navigationTimer?.cancel();
    setState(() {
      _isNavigating = false;
    });
  }

  void _startNavigation() {
    if (_routeCoordinates.isEmpty) return;

    _navigationTimer?.cancel();
    _routeIndex = 0;

    setState(() {
      _isNavigating = true;
    });

    // Update position every second to simulate movement
    _navigationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_routeIndex < _routeCoordinates.length - 1) {
        setState(() {
          _routeIndex++;
          _updateDistanceAndTime();

          // Update current position marker
          _markers.removeWhere((marker) => marker.markerId.value == 'current');
          _markers.add(
            Marker(
              markerId: const MarkerId('current'),
              position: _routeCoordinates[_routeIndex],
              infoWindow: const InfoWindow(title: 'Your location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
              rotation: _calculateBearing(
                _routeCoordinates[_routeIndex - 1],
                _routeCoordinates[_routeIndex],
              ),
            ),
          );

          // Move camera to follow position
          _controller.future.then((controller) {
            controller.animateCamera(
              CameraUpdate.newLatLng(_routeCoordinates[_routeIndex]),
            );
          });
        });
      } else {
        // Reached destination
        _stopNavigation();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have reached your destination!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  double _calculateBearing(LatLng begin, LatLng end) {
    double lat1 = begin.latitude * pi / 180;
    double lon1 = begin.longitude * pi / 180;
    double lat2 = end.latitude * pi / 180;
    double lon2 = end.longitude * pi / 180;

    double dLon = lon2 - lon1;

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double bearing = atan2(y, x);

    bearing = bearing * 180 / pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  void _updateDistanceAndTime() {
    if (_routeIndex >= _routeCoordinates.length - 1) {
      _distanceRemaining = 0;
      _timeRemaining = 0;
      return;
    }

    double totalDistance = 0;
    for (int i = _routeIndex; i < _routeCoordinates.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        _routeCoordinates[i].latitude,
        _routeCoordinates[i].longitude,
        _routeCoordinates[i + 1].latitude,
        _routeCoordinates[i + 1].longitude,
      );
    }

    _distanceRemaining = totalDistance;
    _timeRemaining = (_distanceRemaining / 15) * 60; // Assuming 15 m/s speed
  }

  loadCurrentLocation() {
    getlocation().then(((value) async {
      print("My current location is : ");
      print(value.latitude.toString() + " " + value.longitude.toString());

      _currentPosition = value;

      _markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: 'My current location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      final address = await getAddressFromLatLng(
        value.latitude,
        value.longitude,
      );
      _startController.text = address;

      CameraPosition cameraPosition = CameraPosition(
        zoom: 16,
        target: LatLng(value.latitude, value.longitude),
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    }));
  }

  // ... [Keep all your existing methods like getlocation, getAddressFromLatLng, etc.] ...

  Future<void> drawRoute(LatLng origin, LatLng destination) async {
    setState(() {
      _polylines.clear();
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}&'
        'key=$googleMapsApiKey&mode=driving',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final points = data['routes'][0]['overview_polyline']['points'];
          _routeCoordinates =
              PolylinePoints()
                  .decodePolyline(points)
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();

          setState(() {
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                points: _routeCoordinates,
                color: Colors.blue,
                width: 5,
              ),
            );

            _updateDistanceAndTime();
          });
        } else {
          throw Exception(data['error_message'] ?? 'Failed to get directions');
        }
      } else {
        throw Exception('Failed to load directions');
      }
    } catch (e) {
      print('Error drawing route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to draw route: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleSearch() async {
    if (_startController.text.isEmpty || _destinationController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final startMarker = _markers.firstWhere(
        (marker) => marker.markerId.value == 'start',
        orElse:
            () => _markers.firstWhere(
              (marker) => marker.markerId.value == 'current',
            ),
      );

      final destinationMarker = _markers.firstWhere(
        (marker) => marker.markerId.value == 'destination',
      );

      await drawRoute(startMarker.position, destinationMarker.position);

      final bounds = LatLngBounds(
        southwest: LatLng(
          startMarker.position.latitude < destinationMarker.position.latitude
              ? startMarker.position.latitude
              : destinationMarker.position.latitude,
          startMarker.position.longitude < destinationMarker.position.longitude
              ? startMarker.position.longitude
              : destinationMarker.position.longitude,
        ),
        northeast: LatLng(
          startMarker.position.latitude > destinationMarker.position.latitude
              ? startMarker.position.latitude
              : destinationMarker.position.latitude,
          startMarker.position.longitude > destinationMarker.position.longitude
              ? startMarker.position.longitude
              : destinationMarker.position.longitude,
        ),
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));

      // Show navigation options
      _showNavigationOptions();
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showNavigationOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('Start Navigation'),
                subtitle: Text(
                  '${_distanceRemaining.toStringAsFixed(1)} meters (~${_timeRemaining.toStringAsFixed(0)} seconds)',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _startNavigation();
                },
              ),
              ListTile(
                leading: Icon(Icons.close),
                title: Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  //----------------------------------heatsopts-----------------------------------------------
  // Add this to your _HomemapState class
  // Update your _generateHeatSpots method
  List<Marker> _generateHeatSpots(
    LatLng center,
    int count,
    double radiusInMeters,
  ) {
    final List<Marker> heatSpots = [];
    final Random random = Random();

    final List<Map<String, dynamic>> crimeData = [
      {
        "image":
            "https://media.istockphoto.com/id/612259368/photo/robber-walking-behind-a-girl.jpg?s=612x612&w=0&k=20&c=haUphw1cXY3z5prtl6_aRmAZVTPd4TslMIMS1YD2-iQ=",
        "description":
            "Multiple harassment reports after dark. Avoid walking alone in this area.",
        "type": "High Risk Area",
        "reports": "12 incidents last month",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1586105254999-6c1f1b4150ed?w=400",
        "description":
            "Several snatching incidents reported. Keep valuables secure.",
        "type": "Snatching Zone",
        "reports": "5 cases last week",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1512850183-6d7990f42385?w=400",
        "description":
            "Recent spike in pickpocketing. Be cautious in crowded places.",
        "type": "Pickpocket Hotspot",
        "reports": "8 incidents yesterday",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1558981852-426c6c22a060?w=400",
        "description":
            "Frequent road accidents due to poor lighting. Cross carefully.",
        "type": "Dangerous Crossing",
        "reports": "3 accidents this week",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=400",
        "description":
            "Scam alerts - fake taxi drivers operating in this zone.",
        "type": "Scam Alert",
        "reports": "15 complaints this month",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=400",
        "description":
            "Drink spiking incidents reported at local bars. Never leave drinks unattended.",
        "type": "Nightlife Warning",
        "reports": "6 cases last weekend",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1550565118-3a14e8d0386f?w=400",
        "description":
            "ATM skimming devices found. Use indoor ATMs during daylight.",
        "type": "Financial Crime Zone",
        "reports": "4 devices found today",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=400",
        "description":
            "Public transport groping incidents. Stay alert during rush hours.",
        "type": "Public Transport Alert",
        "reports": "9 reports this week",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1589998059171-988d887df646?w=400",
        "description":
            "Fake police officers stopping pedestrians. Always ask for ID.",
        "type": "Impersonation Alert",
        "reports": "3 incidents yesterday",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=400",
        "description": "Cyclists targeting pedestrians for phone snatching.",
        "type": "Mobile Snatching",
        "reports": "7 cases in 2 days",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1476231682828-37e571bc172f?w=400",
        "description":
            "Park mugging incidents after sunset. Avoid shortcuts through the park.",
        "type": "Park Safety Warning",
        "reports": "5 muggings last week",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=400",
        "description":
            "Residential break-ins reported. Ensure doors/windows are secured.",
        "type": "Burglary Alert",
        "reports": "12 break-ins this month",
      },
    ];

    for (int i = 0; i < count; i++) {
      final double radiusInDegrees = radiusInMeters / 111000;
      final double angle = random.nextDouble() * 2 * pi;
      final double distance = random.nextDouble() * radiusInDegrees;
      final double newLat = center.latitude + (distance * cos(angle));
      final double newLng = center.longitude + (distance * sin(angle));

      final crimeInfo = crimeData[i % crimeData.length];

      heatSpots.add(
        Marker(
          markerId: MarkerId('heatspot_$i'),
          position: LatLng(newLat, newLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'Safety Alert',
            snippet: crimeInfo['type'],
            onTap: () {
              _showCustomInfoWindow(context, crimeInfo);
            },
          ),
        ),
      );
    }

    return heatSpots;
  }

  void _showCustomInfoWindow(
    BuildContext context,
    Map<String, dynamic> crimeInfo,
  ) {
    // We'll use a modal bottom sheet that looks like a card
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CrimeInfoCard(crimeInfo: crimeInfo),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Add emergency action here
                  },
                  child: Text(
                    'GET HELP NOW',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Add this new method to show crime details
  void _showCrimeDetailsDialog(
    BuildContext context,
    Map<String, dynamic> crimeInfo,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Safety Alert: ${crimeInfo['type']}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      crimeInfo['image'],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 150,
                            color: Colors.grey[200],
                            child: Icon(Icons.warning, color: Colors.red),
                          ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    crimeInfo['description'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    crimeInfo['reports'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Safety Tips:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text('• Avoid walking alone in this area'),
                  Text('• Stay in well-lit areas'),
                  Text('• Keep emergency contacts handy'),
                  Text('• Use trusted transportation'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  // Add functionality to report or get help
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Connecting you to local authorities...'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: Text('GET HELP'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }

  Set<Circle> _generateHeatCircles() {
    final Set<Circle> circles = {};
    final Random random = Random();
    final defaultLocation = LatLng(25.4297089, 81.7728296);

    for (int i = 0; i < 5; i++) {
      final double radiusInDegrees = 500 / 111000;
      final double angle = random.nextDouble() * 2 * pi;
      final double distance = random.nextDouble() * radiusInDegrees;
      final double newLat = defaultLocation.latitude + (distance * cos(angle));
      final double newLng = defaultLocation.longitude + (distance * sin(angle));

      circles.add(
        Circle(
          circleId: CircleId('heatcircle_$i'),
          center: LatLng(newLat, newLng),
          radius: 100, // meters
          fillColor: Colors.red.withOpacity(0.3),
          strokeColor: Colors.red,
          strokeWidth: 1,
        ),
      );
    }

    return circles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              circles: _generateHeatCircles(),
              initialCameraPosition: _kGooglePLex,
              markers: Set<Marker>.of(_markers),
              polylines: _polylines,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Compact "From" field
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _startController,
                            focusNode: _startFocusNode,
                            decoration: InputDecoration(
                              hintText: 'From',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 20,
                              ),
                              suffixIcon:
                                  _startController.text.isNotEmpty
                                      ? IconButton(
                                        icon: Icon(Icons.clear, size: 16),
                                        onPressed: () {
                                          _startController.clear();
                                          _markers.removeWhere(
                                            (marker) =>
                                                marker.markerId.value ==
                                                'start',
                                          );
                                          _polylines.clear();
                                          setState(() {});
                                        },
                                      )
                                      : null,
                            ),
                            onChanged: (value) {
                              _debouncer.run(
                                () => _handleStartInputChange(value),
                              );
                            },
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey[200]),
                        // Compact "To" field
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _destinationController,
                            focusNode: _destinationFocusNode,
                            decoration: InputDecoration(
                              hintText: 'To',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 20,
                              ),
                              suffixIcon:
                                  _destinationController.text.isNotEmpty
                                      ? IconButton(
                                        icon: Icon(Icons.clear, size: 16),
                                        onPressed: () {
                                          _destinationController.clear();
                                          _markers.removeWhere(
                                            (marker) =>
                                                marker.markerId.value ==
                                                'destination',
                                          );
                                          _polylines.clear();
                                          setState(() {});
                                        },
                                      )
                                      : null,
                            ),
                            onChanged: (value) {
                              _debouncer.run(
                                () => _handleDestinationInputChange(value),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_startSuggestions.isNotEmpty && _startFocusNode.hasFocus)
                    _buildSuggestionsList(
                      _startSuggestions,
                      _selectStartSuggestion,
                    ),
                  if (_destinationSuggestions.isNotEmpty &&
                      _destinationFocusNode.hasFocus)
                    _buildSuggestionsList(
                      _destinationSuggestions,
                      _selectDestinationSuggestion,
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _isLoading ? null : handleSearch,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Search Route',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation info panel
            if (_isNavigating)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Distance remaining:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_distanceRemaining.toStringAsFixed(1)} meters',
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time remaining:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${_timeRemaining.toStringAsFixed(0)} seconds'),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: _stopNavigation,
                          child: Text(
                            'Stop Navigation',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //--------------heatsopts-------------------------
          FloatingActionButton(
            heroTag: 'heatspots',
            backgroundColor: Colors.white,
            splashColor: Colors.red,
            shape: const CircleBorder(),
            onPressed: () {
              // Remove existing heatspots
              _markers.removeWhere(
                (marker) => marker.markerId.value.startsWith('heatspot'),
              );

              // Generate new ones near current position or default location
              LatLng center =
                  _currentPosition != null
                      ? LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      )
                      : LatLng(25.4297089, 81.7728296);

              final heatSpots = _generateHeatSpots(center, 10, 500);
              _markers.addAll(heatSpots);

              setState(() {});
            },
            child: const Icon(Icons.whatshot, size: 24, color: Colors.red),
          ),

          FloatingActionButton(
            heroTag: 'location',
            backgroundColor: Colors.white,
            splashColor: Colors.blue,
            shape: const CircleBorder(),
            onPressed: () async {
              getlocation().then(((value) async {
                _currentPosition = value;
                _markers.removeWhere(
                  (marker) => marker.markerId.value == 'current',
                );
                _markers.add(
                  Marker(
                    markerId: const MarkerId('current'),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: const InfoWindow(title: 'Your location'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue,
                    ),
                  ),
                );

                final address = await getAddressFromLatLng(
                  value.latitude,
                  value.longitude,
                );
                _startController.text = address;

                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(value.latitude, value.longitude),
                  ),
                );
                setState(() {});
              }));
            },
            child: const Icon(Icons.my_location, size: 24, color: Colors.blue),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'clear',
            backgroundColor: Colors.white,
            splashColor: Colors.red,
            shape: const CircleBorder(),
            onPressed: () {
              _stopNavigation();
              _startController.clear();
              _destinationController.clear();
              _markers.clear();
              _polylines.clear();
              _routeCoordinates.clear();
              loadCurrentLocation();
            },
            child: const Icon(Icons.clear, size: 24, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList(
    List<dynamic> suggestions,
    Function(Map<String, dynamic>) onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: suggestions.length > 5 ? 5 : suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            dense: true,
            leading: const Icon(
              Icons.location_on,
              color: Colors.grey,
              size: 20,
            ),
            title: Text(
              suggestion['description'],
              style: TextStyle(fontSize: 14),
            ),
            onTap: () => onTap(suggestion),
          );
        },
      ),
    );
  }
}
