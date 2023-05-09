import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/BlurredImageCard.dart';
import 'package:tanun_projet_space/components/Empty.dart';
import 'package:tanun_projet_space/components/Loader.dart';
import 'package:tanun_projet_space/components/MenuIcon.dart';
import 'package:tanun_projet_space/components/MenuTitle.dart';
import 'package:tanun_projet_space/pages/Diary.dart';
import 'package:tanun_projet_space/pages/Faq.dart';
import 'package:tanun_projet_space/pages/Garden.dart';
import 'package:tanun_projet_space/pages/HeathBenefit.dart';
import 'package:tanun_projet_space/pages/PlantingMethod.dart';
import 'package:tanun_projet_space/pages/Soil.dart';
import 'package:tanun_projet_space/pages/SuggestPlant.dart';
import 'package:tanun_projet_space/pages/Tips.dart';
import 'package:tanun_projet_space/utils/greetings.dart';
import 'package:tanun_projet_space/utils/http.dart';
import 'package:tanun_projet_space/utils/storage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<List<Map>> _loadTips() async {
    List<Map> _tips = [];

    var response = await dio.get('/api/tips');

    for (var res in response.data) {
      _tips.add(res);
    }
    return _tips;
  }

  Future<List<Map>> _loadSuggestedPlants() async {
    List<Map> _s = [];

    dio.options.headers['authorization'] = 'Bearer ${box.read('userToken')}';

    var response = await dio.get('/api/suggested-plants');

    for (var res in response.data) {
      _s.add(res);
    }
    return _s;
  }

  final List<Map<String, dynamic>> _menus = [
    {"label": "Plants", "image": "plant.png", "page": const Garden()},
    {"label": "Soil", "image": "soil.png", "page": const Soil()},
    {
      "label": "Planting Method",
      "image": "planting.png",
      "page": const PlantingMethod()
    },
    {
      "label": "Health Benefits",
      "image": "health.png",
      "page": const HealthBenefit()
    },
    {"label": "Diary", "image": "diary.png", "page": const Diary()},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              greetings(box.read('userName')),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Text(
              getRandomPlantingQuote(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          // menu list

          const MenuTitle(title: "Features"),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 75,
            child: ListView.builder(
              itemCount: _menus.length,
              itemBuilder: (BuildContext context, int index) {
                return MenuIcon(
                  imagePath: 'assets/images/${_menus[index]['image']}',
                  onTap: () {
                    Get.to(_menus[index]['page']);
                  },
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const MenuTitle(title: "Cultivating tips"),
          const SizedBox(height: 10),
          FutureBuilder(
              builder: (context, ss) {
                if (ss.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return BlurredImageCard(
                          imagePath: "${ss.data![index]['cover']}",
                          title: ss.data![index]['title'],
                          onPressed: () {
                            // print(ss.data![index].runtimeType);
                            final Map<dynamic, dynamic> d = ss.data![index];
                            Get.to(Tips(tip: d));
                          },
                        );
                      },
                      itemCount: ss.data!.length,
                    ),
                  );
                }
                return const Loader();
              },
              future: _loadTips()),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MenuTitle(title: "Suggested plants"),
              IconButton(onPressed: () {
                Get.to(const SuggessPlant());
              }, icon: const Icon(Icons.add))
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: FutureBuilder(
              builder: (context, ss) {
                if (ss.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }

                if (ss.connectionState == ConnectionState.done) {
                  if (ss.data!.isEmpty) {
                    return const Empty();
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://tanum.projet.space/storage/${ss.data![index]['image']}',
                            width: 50,
                            height: 50,
                            cacheHeight: 50,
                            cacheWidth: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title:  Text(ss.data![index]['common_name'],),
                        subtitle: Text(ss.data![index]['scientific_name']),
                        trailing: SizedBox(
                          height: 25,
                          width: 60,
                          child: Text(
                            ss.data![index]['status'],
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: ss.data!.length,
                  );
                }
                return const Empty();
              },
              future: _loadSuggestedPlants(),
            ),
          ),
        ],
      ),
    );
  }
}
