import 'package:flutter/cupertino.dart';

class MenuIcon extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;
  const MenuIcon({Key? key, required this.imagePath, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75,
        height: 75,
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        decoration: const BoxDecoration(
            color: Color(0xFF8fff98),
            // color: Colors.green,
            borderRadius:
            BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Image.asset(
            // 'assets/images/${_menus[index]['image']}',
            imagePath,
            height: 50,
            width: 50,
          ),
        ),
      ),
    );
  }
}
