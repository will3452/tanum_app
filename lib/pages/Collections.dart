import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/Loader.dart';
import 'package:tanun_projet_space/pages/Home.dart';
import 'package:tanun_projet_space/utils/http.dart';

import '../components/NetworkWithFallbackError.dart';
import '../utils/storage.dart';
import 'PlantInfo.dart';

class Collections extends StatefulWidget {
  const Collections({Key? key}) : super(key: key);

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  List<dynamic> _collections = [];
  bool _loading = false;

  void _loadCollections() async {
    setState(() {
      _loading = true;
    });

    var response = await dio.get('/api/collections');

    setState(() {
      _collections = response!.data;
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCollections();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Loader();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .8,
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                'MY COLLECTIONS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String? status = _collections[index]['status'] ?? 'Planting';
                  return ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Hero(
                        tag:
                            'plant-preview-${_collections[index]['plant']['id']}',
                        child: NetworkImageWithFallback(
                          imageUrl:
                              'https://tanum.projet.space/storage/${_collections[index]['plant']['image']}',
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
                    title: GestureDetector(
                      child: Text(_collections[index]['plant']['common_name']),
                      onTap: () {
                        Get.to(PlantInfo(plant: _collections[index]['plant']));
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_collections[index]['plant']['scientific_name']),
                        Text(_collections[index]['plant']['type']),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 160,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 70,
                            child: DropdownButton(
                              isExpanded: true,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Planted',
                                  child: Text('Planted'),
                                ),
                                DropdownMenuItem(
                                  value: 'Planting',
                                  child: Text('Planting'),
                                ),
                              ],
                              onChanged:  (e) async {
                                var token = box.read('userToken');

                                dio.options.headers['Accept'] = 'application/json';
                                dio.options.headers['Authorization'] = 'Bearer $token';
                                // submit task
                                await dio.put('/api/collections/${_collections[index]['plant']['id']}', data: {
                                  "status": e,
                                });
                                Get.defaultDialog(content: const Text("plant status has been updated.Please reload the list by revisiting to this page."), title: "Success");
                              },
                              value: status,
                            ),
                          ),
                          MaterialButton(onPressed: () async {
                            var token = box.read('userToken');

                            dio.options.headers['Accept'] = 'application/json';
                            dio.options.headers['Authorization'] = 'Bearer $token';
                            // submit task
                            await dio.delete('/api/collections/${_collections[index]['plant']['id']}');
                            Get.defaultDialog(content: const Text("plant has been removed to the collection.please reload the list by revisiting to this page."), title: "Success");
                          }, child: const Icon(Icons.remove),)
                        ],
                      ),
                    ),
                  );
                },
                itemCount: _collections.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
