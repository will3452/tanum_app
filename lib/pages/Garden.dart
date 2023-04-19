import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart"
    show
        AppBar,
        BuildContext,
        Center,
        CircularProgressIndicator,
        ConnectionState,
        DefaultTabController,
        EdgeInsets,
        Expanded,
        FutureBuilder,
        Icon,
        IconButton,
        Icons,
        Key,
        ListTile,
        ListView,
        Padding,
        SafeArea,
        Scaffold,
        State,
        StatefulWidget,
        Tab,
        TabBar,
        TabBarView,
        Text,
        TextOverflow,
        Widget;
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/NetworkWithFallbackError.dart';
import 'package:tanun_projet_space/components/PlantList.dart';
import 'package:tanun_projet_space/pages/PlantInfo.dart';
import '../pages/Home.dart';
import '../utils/http.dart';

class Garden extends StatefulWidget {
  const Garden({Key? key}) : super(key: key);

  @override
  State<Garden> createState() => _GardenState();
}

class _GardenState extends State<Garden> {
  Future<List<Map>> _loadPlants(String typeOfPlant) async {
    List<Map> plants = [];
    var response = await dio
        .get('/api/plants', queryParameters: {"search": "type:$typeOfPlant"});
    for (int i = 0; i < response.data.length; i++) {
      plants.add(response.data[i]);
    }
    return plants;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              child: Text('Decorated'),
            ),
            Tab(
              child: Text('Root'),
            ),
            Tab(
              child: Text('Vegetable'),
            ),
          ]),
          leading: IconButton(
            onPressed: () {
              Get.to(const Home());
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Garden'),
        ),
        body: TabBarView(
          children: [
            PlantList(plantType: "Decorated"),
            PlantList(plantType: "Root"),
            PlantList(plantType: "Vegetable"),
          ],
        ),
      ),
    );
  }
}
