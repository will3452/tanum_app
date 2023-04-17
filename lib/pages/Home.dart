import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/pages/Calendar.dart';
import 'package:tanun_projet_space/pages/Collections.dart';
import 'package:tanun_projet_space/pages/Dashboard.dart';
import 'package:tanun_projet_space/pages/Login.dart';
import 'package:tanun_projet_space/utils/http.dart';
import 'package:tanun_projet_space/utils/storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentMenu = 1;
  bool _isLoading = false;

  List<Widget> _menus = [
    Calendar(),
    Dashboard(),
    Collections(),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.menu,
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
                            Get.defaultDialog(
                              title: "Please wait",
                              content: const CircularProgressIndicator(),
                            );
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
        ),
        body: _menus[_currentMenu],
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentMenu,
          onTap: (index) {
            setState(() {
              _currentMenu = index;
            });
          },
          backgroundColor: Colors.white,
          color: Colors.green,
          items: const <Widget>[
            Icon(
              Icons.calendar_month,
              size: 40,
              color: Colors.white,
            ),
            Icon(
              Icons.home,
              size: 40,
              color: Colors.white,
            ),
            Icon(
              Icons.folder,
              size: 40,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
