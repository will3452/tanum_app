import 'package:flutter/material.dart';
import 'package:tanun_projet_space/components/Article.dart';
import 'package:tanun_projet_space/components/TextJustify.dart';

class Soil extends StatelessWidget {
  const Soil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soil'),
      ),
      body: SafeArea(
        child: ListView(
          children:  [
            Article(textContent: '''Soil is one of the most valuable natural resources on Earth. It is a complex mixture of organic matter, minerals, water, and air that provides the necessary conditions for plants to grow. Soil comes in a variety of types, each with its own unique properties and characteristics.

One of the most common ways to classify soil is based on its texture. Soil texture is determined by the size of the particles that make up the soil. The three main types of soil based on texture are sandy, clay, and loam.

Sandy soil has a coarse texture and feels gritty to the touch. It drains quickly and does not hold nutrients well. However, it warms up quickly in the spring, making it an ideal soil for early planting.

Clay soil, on the other hand, has a fine texture and feels sticky to the touch. It drains slowly and can become compacted easily, making it difficult for plant roots to grow. However, clay soil is rich in nutrients and can hold moisture well.

Loam soil is a combination of sand, silt, and clay, making it a well-balanced soil that is ideal for growing most plants. It has good drainage and water-holding capacity and is rich in nutrients.

Another way to classify soil is based on its pH level. Soil pH is a measure of the acidity or alkalinity of the soil. The pH scale ranges from 0 to 14, with 7 being neutral. Soils with a pH below 7 are acidic, while soils with a pH above 7 are alkaline.

Acidic soil is common in areas with high rainfall, and it can be challenging to grow plants in these soils. However, some plants, such as blueberries and azaleas, prefer acidic soil.

Alkaline soil is common in areas with low rainfall and can be found in arid and desert regions. Plants that prefer alkaline soil include cacti and succulents.

In conclusion, soil is a vital natural resource that plays a crucial role in the growth and development of plants. Soil comes in a variety of types, each with its own unique properties and characteristics. Understanding the different types of soil and their properties can help gardeners and farmers choose the best soil for their crops and improve soil health.''', image: 'assets/images/soil.jpg')
          ],          ),
      ),
    );
  }
}
