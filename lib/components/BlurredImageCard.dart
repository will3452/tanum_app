import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredImageCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onPressed;

  const BlurredImageCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 180,
          child: SizedBox(
            child: InkWell(
              onTap: onPressed,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Hero(
                      tag: 'https://tanum.projet.space/storage/$imagePath',
                      child: Image.network(
                        "https://tanum.projet.space/storage/$imagePath",
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: .8, sigmaY: .8),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w100
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
