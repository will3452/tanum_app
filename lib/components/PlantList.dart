import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/Loader.dart';

import '../pages/PlantInfo.dart';
import '../utils/http.dart';
import '../utils/storage.dart';
import 'NetworkWithFallbackError.dart';

class PlantList extends StatefulWidget {
  final String plantType;

  PlantList({required this.plantType});

  @override
  _PlantListState createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {
  late Future<List<dynamic>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _plantsFuture = _loadPlants(widget.plantType);
  }

  Future<List<dynamic>> _loadPlants(String plantType) async {
    List<Map> plants = [];
    var response = await dio
        .get('/api/plants', queryParameters: {"search": "type:$plantType"});
    for (int i = 0; i < response.data.length; i++) {
      plants.add(response.data[i]);
    }
    return plants;
  }

  void _addToCollections(int plantId) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Adding plant, please be patient."),
        ),
      );
      dio.options.headers['authorization'] = "Bearer ${box.read('userToken')}";
      var response =
          await dio.post('/api/collections', data: {"plant_id": plantId});

      Get.defaultDialog(
        title: "Success",
        content: const Text("Plant has been added to your collections."),
      );
    } on DioError catch (e) {
      Get.defaultDialog(
        title: "Failed",
        content: Text("${e.response!.data['message']}"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: _plantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (builder, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(PlantInfo(plant: snapshot.data![index]));
                  },
                  child: ListTile(
                    dense: true,
                    leading: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Hero(
                        tag: 'plant-preview-${snapshot.data![index]['id']}',
                        child: NetworkImageWithFallback(
                          imageUrl:
                              'https://tanum.projet.space/storage/${snapshot.data![index]['image']}',
                          fallback: (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 65,
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) {
                              return child;
                            } else if (progress.cumulativeBytesLoaded ==
                                progress.expectedTotalBytes) {
                              return child;
                            } else {
                              return SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                        : 0,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    title: Text(snapshot.data![index]['common_name']),
                    subtitle: Text(snapshot.data![index]['scientific_name']),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _addToCollections(snapshot.data![index]['id']);
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Loader());
          }
          return const Center(
            child: Text('No data found'),
          );
        },
      ),
    );
  }
}
