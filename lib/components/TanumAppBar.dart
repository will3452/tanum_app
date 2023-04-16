import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../utils/storage.dart';
import '../utils/http.dart';
import '../pages/Login.dart';


AppBar TanumAppBar() {
  return AppBar(
    leading: const Icon(
      Icons.grass,
    ),
    title: const Text('Tanum'),
    actions: [
      IconButton(
        onPressed: () {
          try {
            Get.defaultDialog(
                title: 'Confirmation',
                content: const Text('Are your sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      dio.options.headers['Authorization'] =
                      'Bearer ${box.read('userToken')}';
                      var response = await dio.post('/api/logout');
                      box.erase();
                      Get.to(const Login());
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('No'),
                  )
                ]);
          } on DioError catch (e) {
            print(e.response);
          }
        },
        icon: const Icon(Icons.exit_to_app),
        tooltip: "Logout",
      )
    ],
  );
}
