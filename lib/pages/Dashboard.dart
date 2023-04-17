import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/BlurredImageCard.dart';
import 'package:tanun_projet_space/components/MenuIcon.dart';
import 'package:tanun_projet_space/components/MenuTitle.dart';
import 'package:tanun_projet_space/pages/Faq.dart';
import 'package:tanun_projet_space/pages/Garden.dart';
import 'package:tanun_projet_space/pages/HeathBenefit.dart';
import 'package:tanun_projet_space/pages/PlantingMethod.dart';
import 'package:tanun_projet_space/pages/Soil.dart';
import 'package:tanun_projet_space/utils/greetings.dart';
import 'package:tanun_projet_space/utils/storage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> _menus = [
    {"label": "Plants", "image": "plant.png", "page": Garden()},
    {"label": "Soil", "image": "soil.png", "page": Soil()},
    {
      "label": "Planting Method",
      "image": "planting.png",
      "page": PlantingMethod()
    },
    {
      "label": "Health Benefits",
      "image": "health.png",
      "page": HealthBenefit()
    },
    {"label": "FAQ", "image": "faq.png", "page": Faq()}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 15,),
          const MenuTitle(title: "Cultivating tips"), 
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                BlurredImageCard(
                    imagePath: 'assets/images/bg.jpg',
                    title: 'PROPER WATERING',
                    onPressed: () {
                      print('pressed!');
                    }),
                BlurredImageCard(
                    imagePath: 'assets/images/bg.jpg',
                    title: 'PROPER SUNLIGHT',
                    onPressed: () {
                      print('pressed!');
                    }),
                BlurredImageCard(
                    imagePath: 'assets/images/bg.jpg',
                    title: 'DEMO',
                    onPressed: () {
                      print('pressed!');
                    }),
              ],
            ),
          ),
          const SizedBox(height: 10,),
          const MenuTitle(title: "Suggested plants"),
        ],
      ),
    );
  }
}
