import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:tanun_projet_space/pages/Home.dart';
import 'package:tanun_projet_space/utils/http.dart';

class Garden extends StatefulWidget {
  const Garden({Key? key}) : super(key: key);

  @override
  State<Garden> createState() => _GardenState();
}

class _GardenState extends State<Garden> {
  Future<List<Map>> _loadPlants() async {
    List<Map> plants = [];
    var response = await dio.get('/api/plants');
    for (int i = 0; i < response.data.length; i++) {
      plants.add(response.data[i]);
    }
    return plants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(Home());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Garden'),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: _loadPlants(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.data);
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (builder, index) {
                    return  ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.network(
                          'https://tanum.projet.space/storage/${snapshot.data![index]['image']}',
                          width: 75,
                          height: 75,
                          cacheHeight: 75,
                          cacheWidth: 75,
                        ),
                      ),
                      title: Text(snapshot.data![index]['common_name']),
                      subtitle: Text(snapshot.data![index]['scientific_name']),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {},
                      )
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Center(
                child: Text('No data found'),
              );
            },
          ),
        ),
      ),
    );
  }
}
