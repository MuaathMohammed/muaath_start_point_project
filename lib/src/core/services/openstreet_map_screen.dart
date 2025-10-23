import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:muaath_start_point_project/src/core/extensions/localization_extensions.dart';
import 'package:muaath_start_point_project/src/core/extensions/translation_extension.dart';
import 'package:muaath_start_point_project/src/core/services/location_service.dart';

class OpenStreetMapScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const OpenStreetMapScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Set initial location from props
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedLocation = LatLng(
        widget.initialLatitude!,
        widget.initialLongitude!,
      );
    }

    // Get current device location
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      _currentLocation = LatLng(position.latitude, position.longitude);
      if (_selectedLocation == null) {
        _selectedLocation = _currentLocation;
      }
    } else {
      // Default to a central location if no GPS available
      _selectedLocation ??= const LatLng(24.7136, 46.6753); // Riyadh, KSA
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _goToCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15.0);
      setState(() {
        _selectedLocation = _currentLocation;
      });
    } else {
      final position = await LocationService.getCurrentLocation();
      if (position != null) {
        final location = LatLng(position.latitude, position.longitude);
        _mapController.move(location, 15.0);
        setState(() {
          _selectedLocation = location;
          _currentLocation = location;
        });
      }
    }
  }

  void _saveLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, {
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_location'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _goToCurrentLocation,
            tooltip: 'current_location'.tr,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation!,
                    initialZoom: 15.0,
                    onTap: _onMapTap,
                  ),
                  children: [
                    // OpenStreetMap Tile Layer
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.muaath_start_point_project',
                    ),
                    // Marker for selected location
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation!,
                            width: 40.0,
                            height: 40.0,
                            child: const Icon(
                              Icons.location_pin,
                              size: 40.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Center marker
                const IgnorePointer(
                  child: Center(
                    child: Icon(
                      Icons.location_searching,
                      size: 32,
                      color: Colors.blue,
                    ),
                  ),
                ),
                // Location info card
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'selected_location'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedLocation != null
                                ? 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}\nLng: ${_selectedLocation!.longitude.toStringAsFixed(6)}'
                                : 'no_location_selected'.tr,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('cancel'.tr),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveLocation,
                                  child: Text('save_location'.tr),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
