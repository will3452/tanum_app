import 'package:flutter/material.dart';
import 'package:tanun_projet_space/utils/greetings.dart';
import 'package:tanun_projet_space/utils/storage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> _menus = [
    {"label": "Plants", "image": "plant.png"},
    {"label": "Soil", "image": "soil.png"},
    {"label": "Planting Method", "image": "planting.png"},
    {"label": "Health Benefits", "image": "health.png"},
    {"label": "FAQ", "image": "faq.png"}
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Text(
            greetings(box.read('userName')),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              getRandomPlantingQuote(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          // menu list

          const Text('Features', style: TextStyle(
            fontSize: 20,
          ),),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            child: ListView.builder(
              itemCount: _menus.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 75,
                        height: 75,
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        decoration: const BoxDecoration(
                            color: Color(0xFF8fff98),
                            // color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: Image.asset(
                            'assets/images/${_menus[index]['image']}',
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                      onTap: () {
                        print(_menus[index]['label']);
                      },
                    ),
                  ],
                );
              },
              scrollDirection: Axis.horizontal,
            ),
          ),

          Text('Cultivating tips', style: TextStyle(
            fontSize: 20,
          ),),
        ],
      ),
    );
  }
}
