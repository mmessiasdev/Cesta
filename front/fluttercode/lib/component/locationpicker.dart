import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng?) onLocationSelected;

  const LocationPicker({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Verifica se a permissão de localização foi concedida
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Se o serviço de localização não estiver habilitado, solicita ao usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, habilite o serviço de localização')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Se a permissão for negada, exibe uma mensagem
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permissão de localização negada')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Se a permissão for negada permanentemente, exibe uma mensagem
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Permissão de localização negada permanentemente')),
      );
      return;
    }

    // Obtém a localização atual
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione a Localização'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_selectedLocation != null) {
                Navigator.pop(context, _selectedLocation); // Retorna um LatLng?
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Por favor, selecione uma localização')),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Exibe um loading enquanto obtém a localização
          : FlutterMap(
              options: MapOptions(
                initialCenter: _currentLocation!, // Centraliza no local atual
                initialZoom: 15.0,
                onTap: (_, LatLng location) {
                  setState(() {
                    _selectedLocation = location;
                  });
                  widget.onLocationSelected(location);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  tileProvider:
                      CancellableNetworkTileProvider(), // Usa o provedor cancelável
                ),
                if (_selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        child: Icon(Icons.location_pin,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
