import "package:flutter/material.dart";
import "package:tanun_projet_space/components/TanumAppBar.dart";

class Garden extends StatefulWidget {
  const Garden({Key? key}) : super(key: key);

  @override
  State<Garden> createState() => _GardenState();
}

class _GardenState extends State<Garden> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TanumAppBar(),
      body: SafeArea(
        child: Text('Garden'),
      ),
    );
  }
}
