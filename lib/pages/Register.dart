import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/pages/Login.dart';
import '../utils/http.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String? _password;
  String? _name;
  String? _email;

  Future<void> _register() async {
    try {
      Get.defaultDialog(
        title: "Please wait",
        content: CircularProgressIndicator(),
      );
      
      var response = await dio.post(
        '/api/register',
        data: {"name": _name, "email": _email, "password": _password},
      );

      Get.defaultDialog(
        title: "Success",
        content: const Text("You're now registered! please login"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.to(Login());
              },
              child: const Text('Ok'))
        ],
      );
    } on DioError catch (e) {
      print(e.response!.data);
      Get.defaultDialog(
          title: "Error", content: Text(e.response!.data['message']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Welcome to Tanum!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Complete your details to continue.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Full Name'),
                          hintText: "Enter your Full Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          suffixIcon: Icon(Icons.mail),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value == '') {
                            return "Please enter your name";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Email'),
                          hintText: "Enter your Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          suffixIcon: Icon(Icons.mail),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        validator: (value) {
                          if (!GetUtils.isEmail(value!)) {
                            return "Please enter valid email";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text('Password'),
                          hintText: "Enter your Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          suffixIcon: Icon(Icons.lock),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        validator: (value) {
                          if (value == '' || value == null) {
                            return 'Please enter password';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: MediaQuery.of(context).viewInsets.bottom == 0,
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _register();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: MediaQuery.of(context).viewInsets.bottom == 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account ?"),
                            GestureDetector(
                              onTap: () {
                                Get.to(Login());
                              },
                              child: const Text(
                                ' Sign in',
                                style: TextStyle(color: Colors.green),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
