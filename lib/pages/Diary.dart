import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/Empty.dart';
import 'package:tanun_projet_space/pages/CreateDiary.dart';

class Diary extends StatelessWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xFFf1f2f3),
      appBar: AppBar(
        title: Text("Diary"),
        actions: [
          IconButton(onPressed: (){
            Get.to(CreateDiary());
          }, icon: Icon(Icons.edit))
        ],
      ),
      body: Empty(),
    );
  }
}
