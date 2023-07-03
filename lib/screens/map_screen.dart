import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:search_bird/bloc/bird_post_cubit.dart';
import 'package:search_bird/bloc/location_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_bird/screens/add_bird_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_bird/screens/bird_info_screen.dart';
import 'dart:io';

import '../models/bird_post_model.dart';

class MapScreen extends StatelessWidget {
  final MapController _mapController = MapController();

  Future<void> _pickImageAndCreatePosy(
      {required LatLng latLng, required BuildContext context}) async {
    File? image;

    final picker = ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickedFile != null) {
      image = File(pickedFile.path);

      //Navigate to new screen

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddBirdScreen(latLng: latLng, image: image!)));
    } else {
      print("User didn't pick image");
    }
  }

  List<Marker> _buildMarkers(BuildContext context, List<BirdModel> birdPosts) {
    List<Marker> markers = [];
    birdPosts.forEach((post) {
      markers.add(Marker(
          width: 55,
          height: 55,
          point: LatLng(post.latitude, post.longitude),
          builder: (ctx) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          BirdPostInfoScreen(birdModel: post)));
                },
                child: Container(
                  child: Image.asset("assets/bird-icon.png"),
                ),
              )));
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Тоже самое что блок билдер только он не билдит а слушает стейты
      body: BlocListener<LocationCubit, LocationState>(
        listener: (previousState, carrentState) {
          if (carrentState is LocationLoaded) {
            _mapController.onReady.then((value) => _mapController.move(
                LatLng(carrentState.latitude, carrentState.longitude), 14));
          }
          if (carrentState is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red.withOpacity(0.6),
              content: Text("Error, unable to fetch location..."),
            ));
          }
        },
        // Мапа создается 1 раз
        child: BlocBuilder<BirdPostCubit, BirdPostState>(
          //возвращает когда новый статус не равен предыдущему
          buildWhen: (prevState, currentState) =>
              (prevState.status != currentState.status),
          builder: (context, birdPostState) {
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onLongPress: (latLng) {
                  _pickImageAndCreatePosy(latLng: latLng, context: context);
                },
                center: LatLng(0, 0),
                zoom: 15.3,
                maxZoom: 17,
                minZoom: 3.5,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  retinaMode: true,
                ),
                MarkerLayerOptions(
                  markers: _buildMarkers(context, birdPostState.birdPosts),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
