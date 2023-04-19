import 'package:flutter/material.dart';
import 'package:tanun_projet_space/components/NetworkWithFallbackError.dart';

class PlantInfo extends StatelessWidget {
  final Map<dynamic, dynamic> plant;
  const PlantInfo({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${plant['common_name']}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Hero(
              tag: 'plant-preview-${plant['id']}',
              child: NetworkImageWithFallback(
                height: 310,
                width: double.infinity,
                imageUrl:
                'https://tanum.projet.space/storage/${plant['image']}',
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
          ListTile(
            title: const Text("Common Name"),
            subtitle: Text('${plant['common_name']}'),
          ),
          ListTile(
            title: const Text("Scientific Name"),
            subtitle: Text('${plant['scientific_name']}'),
          ),
          ListTile(
            title: const Text("Habitat"),
            subtitle: Text('${plant['habitat']}'),
          ),
          ListTile(
            title: const Text("Family"),
            subtitle: Text('${plant['family']}'),
          ),
          ListTile(
            title: const Text("Descriptions"),
            subtitle: Text('${plant['description']}'),
          ),
          ListTile(
            title: const Text("Tips"),
            subtitle: Text('${plant['tips']}'),
          ),
          ListTile(
            title: const Text("Temp"),
            subtitle: Text('${plant['temp']}'),
          ),
          ListTile(
            title: const Text("Air"),
            subtitle: Text('${plant['air']}'),
          ),
          ListTile(
            title: const Text("Light"),
            subtitle: Text('${plant['light']}'),
          ),
        ],
      ),
    );
  }
}
