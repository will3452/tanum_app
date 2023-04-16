import 'package:dio/dio.dart';
import './storage.dart';


final dio = Dio(
  BaseOptions(
    baseUrl: 'https://tanum.projet.space',
    connectTimeout: const Duration(seconds: 5),
  )
);