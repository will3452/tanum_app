import 'package:flutter/cupertino.dart';
import './TextJustify.dart';

class Article extends StatelessWidget {
  final String textContent;
  final String image;
  final bool isNeworkImage;
  const Article(
      {Key? key,
      required this.textContent,
      required this.image,
      this.isNeworkImage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isNeworkImage) {
      return Column(
        children: [
          Image.asset(image),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextJustify(textContent: textContent),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Hero(
            tag: "https://tanum.projet.space/storage/${image}",
            child: Image.network("https://tanum.projet.space/storage/${image}"),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextJustify(textContent: textContent),
          )
        ],
      );
    }
  }
}
