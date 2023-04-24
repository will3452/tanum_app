import 'package:flutter/material.dart';
import 'package:tanun_projet_space/components/Article.dart';
import 'package:tanun_projet_space/components/TextJustify.dart';

class PlantingMethod extends StatelessWidget {
  const PlantingMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Planting methods'),
            bottom: const TabBar(isScrollable: true, tabs: [
              Tab(
                child: Text('Direct Sowing'),
              ),
              Tab(
                child: Text('Transplanting'),
              ),
              Tab(
                child: Text('Container Gardening'),
              ),
              Tab(
                child: Text('Raised Bed Gardening'),
              ),
              Tab(
                child: Text('Hydroponics'),
              ),
            ]),
          ),
          body: TabBarView(
            children: [
              ListView(
                children: const [
                  Article(
                    textContent:
                    "Direct sowing involves planting seeds directly into the soil where they will grow. This method is ideal for hardy plants like beans, peas, and radishes. Direct sowing is a cost-effective way to start a garden, and it's easy to get started. However, this method may not be suitable for more delicate plants that require a controlled environment to germinate.",
                    image: "assets/images/sowing.webp",
                  ),
                ],
              ),
              ListView(
                children: const [
                  Article(
                    textContent: "Transplanting involves starting plants indoors or in a greenhouse and then transplanting them to their final location in the garden. This method is ideal for plants that require a longer growing season or a warmer climate than what is available outdoors. Transplanting also allows for greater control over the growing environment, which can be beneficial for sensitive plants. However, it can be more time-consuming and requires extra care when moving the plants.",
                    image: "assets/images/transplanting.jpg",
                  ),
                ],
              ),
              ListView(
                children: const [
                  Article(
                    textContent: "Container gardening is a planting method that involves growing plants in pots or containers. This method is ideal for gardeners with limited space, as containers can be placed on balconies, patios, or rooftops. Container gardening also allows for greater flexibility in terms of plant placement and can be used to grow a variety of plants, including herbs, vegetables, and flowers.",
                    image: "assets/images/container.webp",
                  ),
                ],
              ),

              ListView(
                children: const [
                  Article(
                    textContent: "Raised bed gardening involves building raised beds and filling them with soil, compost, and other organic matter. This method provides better drainage and allows for greater control over the soil composition, which can be beneficial for plants that require specific growing conditions. Raised bed gardening also reduces the risk of soil-borne diseases and can make gardening more accessible for people with mobility issues.",
                    image: "assets/images/rbg.jpeg",
                  ),
                ],
              ),
              ListView(
                children: const [
                  Article(
                    textContent:"Hydroponics is a method of growing plants without soil. Instead, plants are grown in a nutrient-rich solution. This method is ideal for gardeners with limited space, as plants can be grown vertically, and it uses less water than traditional gardening methods. Hydroponics also allows for greater control over the growing environment, which can be beneficial for sensitive plants.",
                    image: "assets/images/hyp.webp",
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}
