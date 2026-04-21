import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Week 4 screen demonstrating runtime permissions + device integrations.
class DeviceFeaturesScreen extends StatefulWidget {
  const DeviceFeaturesScreen({super.key});

  @override
  State<DeviceFeaturesScreen> createState() => _DeviceFeaturesScreenState();
}

class _DeviceFeaturesScreenState extends State<DeviceFeaturesScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  String _locationStatus = 'Location not requested yet.';
  String _nearestPoiStatus = 'Nearest campus point not calculated yet.';
  XFile? _pickedImage;
  double _accelerationMagnitude = 0;

  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;

  final List<_CampusPoi> _campusPois = const [
    _CampusPoi('Library', 35.7101, -0.6343),
    _CampusPoi('Main Gate', 35.7092, -0.6332),
    _CampusPoi('Engineering Block', 35.7113, -0.6358),
  ];

  @override
  void initState() {
    super.initState();

    // Sensors demo: continuously read acceleration to visualize motion.
    _accelerometerSubscription = userAccelerometerEventStream().listen((event) {
      final magnitude = math.sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      if (mounted) {
        setState(() {
          _accelerationMagnitude = magnitude;
        });
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission permanently denied. Open system settings to enable it.',
          ),
        ),
      );
      await openAppSettings();
    }

    return false;
  }

  Future<void> _loadCurrentLocation() async {
    final hasPermission = await _requestPermission(
      Permission.locationWhenInUse,
    );

    if (!hasPermission) {
      if (mounted) {
        setState(() {
          _locationStatus = 'Location permission denied.';
        });
      }
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _locationStatus = 'Location service is disabled on this device.';
        });
      }
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    _CampusPoi? nearestPoi;
    double nearestDistance = double.infinity;

    for (final poi in _campusPois) {
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        poi.latitude,
        poi.longitude,
      );

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestPoi = poi;
      }
    }

    if (mounted) {
      setState(() {
        _locationStatus =
            'Current location: ${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';
        if (nearestPoi != null) {
          _nearestPoiStatus =
              'Nearest POI: ${nearestPoi.name} (${nearestDistance.toStringAsFixed(1)} m away)';
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final requiredPermission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;

    final hasPermission = await _requestPermission(requiredPermission);
    if (!hasPermission) {
      return;
    }

    final file = await _imagePicker.pickImage(source: source, imageQuality: 80);
    if (file == null || !mounted) {
      return;
    }

    setState(() {
      _pickedImage = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Features Lab')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Week 4 Integrations',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          const Card(
            child: ListTile(
              leading: Icon(Icons.security_outlined),
              title: Text('Runtime Permission Model'),
              subtitle: Text(
                'This screen requests camera/gallery/location permissions during runtime.',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location + Campus POI',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(_locationStatus),
                  const SizedBox(height: 6),
                  Text(_nearestPoiStatus),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: _loadCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Get Current Location'),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Camera/Gallery Attachment',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Camera'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                    ],
                  ),
                  if (_pickedImage != null) const SizedBox(height: 10),
                  if (_pickedImage != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_pickedImage!.path),
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('Selected file: ${_pickedImage!.name}'),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sensors_outlined),
              title: const Text('Accelerometer (Concept Demo)'),
              subtitle: Text(
                'Current acceleration magnitude: ${_accelerationMagnitude.toStringAsFixed(2)}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampusPoi {
  const _CampusPoi(this.name, this.latitude, this.longitude);

  final String name;
  final double latitude;
  final double longitude;
}
