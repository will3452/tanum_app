import 'package:flutter/material.dart';

class TextJustify extends StatelessWidget {
  final String textContent;
  const TextJustify({Key? key, required this.textContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(textContent,
      style: const TextStyle(
        fontSize: 16,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
