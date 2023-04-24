import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/Loader.dart';
import 'package:tanun_projet_space/utils/http.dart';

import '../components/NetworkWithFallbackError.dart';
import 'PlantInfo.dart';

class Collections extends StatefulWidget {
  const Collections({Key? key}) : super(key: key);

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {

  List<dynamic> _collections = [];
  bool _loading = false;

  void _loadCollections () async{
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
    if (_loading) return Loader();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .8,
        child: Column(
          children: [
             SizedBox(
               width: double.infinity,
               child: const Text(
                'MY COLLECTIONS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
            ),
             ),
            Expanded(
              child: ListView.builder(itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(PlantInfo(plant: _collections[index]['plant']));
                  },
                  child: ListTile(

                    leading: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Hero(
                        tag: 'plant-preview-${_collections[index]['plant']['id']}',
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
                    title: Text(_collections[index]['plant']['common_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_collections[index]['plant']['scientific_name']),
                        Text(_collections[index]['plant']['type']),
                      ],
                    ),
                  ),
                );
              }, itemCount: _collections.length,),
            )
          ],
        ),
      ),
    );
  }
}
