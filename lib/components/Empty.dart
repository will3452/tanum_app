import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
          'No Data Found.',
          style: TextStyle(
            color: Colors.black26,
            fontSize: 18,
          ),
        ),
    );
  }
}
