import 'package:dio/dio.dart';


final dio = Dio(
  BaseOptions(
    baseUrl: 'https://tanum.projet.space',
    // baseUrl: 'http://10.111.6.138:8000',
    connectTimeout: const Duration(seconds: 60),
  )
);