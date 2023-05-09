import 'package:flutter/material.dart';
import 'package:tanun_projet_space/components/NetworkWithFallbackError.dart';

class DiaryInfo extends StatelessWidget {
  final Map<dynamic, dynamic> diary;
  const DiaryInfo({Key? key, required this.diary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${diary['title']}'),
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
              tag: 'diary-preview-${diary['id']}',
              child: NetworkImageWithFallback(
                height: 310,
                width: double.infinity,
                imageUrl:
                'https://tanum.projet.space/storage/${diary['image']}',
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
            title: const Text("Title"),
            subtitle: Text('${diary['title']}'),
          ),
          ListTile(
            title: const Text("Body"),
            subtitle: Text('${diary['body']}'),
          ),
      ],
      ),
    );
  }
}
