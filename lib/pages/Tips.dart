import 'package:flutter/material.dart';
import 'package:tanun_projet_space/components/Article.dart';
class Tips extends StatelessWidget {
  final Map<dynamic, dynamic> tip;
  const Tips({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tip['title']),
      ),
      body: SizedBox(
        width: double.infinity,
        child: ListView(children: [
          Article(
            textContent: tip['content'],
            image: "${tip['cover']}",
            isNeworkImage: true,
          ),
        ]),
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
