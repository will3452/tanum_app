import 'package:flutter/material.dart';
import 'package:tanun_projet_space/pages/Login.dart';
import 'package:get/get.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final PageController _pg = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: PageView(
                controller: _pg,
                pageSnapping: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Column(
                    children: [
                      const Text(
                        'TANUM',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      Image.asset('assets/images/tut1.png'),
                      const Text(
                        'A Step towards better tomorrow',
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _pg.nextPage(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.slowMiddle);
                        },
                        child: Text('NEXT'),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'TANUM',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      Image.asset('assets/images/tut2.png'),
                      const Text(
                        'What you plant now, you will harvest later.',
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _pg.nextPage(
                              duration: Duration(milliseconds: 100),
                              curve: Curves.slowMiddle);
                        },
                        child: Text('NEXT'),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'TANUM',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Image.asset('assets/images/tut3.png'),
                      Text(
                        'Plant a hope for the future.',
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(const Login());
                        },
                        child: Text('Proceed to login!'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
