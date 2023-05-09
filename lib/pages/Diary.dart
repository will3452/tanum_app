import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanun_projet_space/components/Empty.dart';
import 'package:tanun_projet_space/components/Loader.dart';
import 'package:tanun_projet_space/components/NetworkWithFallbackError.dart';
import 'package:tanun_projet_space/pages/CreateDiary.dart';
import 'package:tanun_projet_space/pages/DiaryInfo.dart';

import '../utils/http.dart';
import '../utils/storage.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {

  var _entries = [];
  bool _loading = false;

  void _loadEntries() async {
    setState(() {
      _loading = true;
    });
    dio.options.headers['Authorization'] = "Bearer ${box.read('userToken')}";

    var response = await dio.get('/api/diary');

    _entries = response!.data;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
          backgroundColor: Color(0xFFf1f2f3),
        body:  Loader(),
      );
    }
    return  Scaffold(
      backgroundColor: Color(0xFFf1f2f3),
      appBar: AppBar(
        title: const Text("Diary"),
        actions: [
          IconButton(onPressed: (){
            Get.to(CreateDiary());
          }, icon: Icon(Icons.edit))
        ],
      ),
      body: _entries.isEmpty ? Empty() : ListView.builder(itemBuilder: (context,index) {
        var date = DateTime.parse(_entries[index]['created_at']);
        return ListTile(
          onTap: () {
            Get.to(DiaryInfo(diary: _entries[index]));
          },
          dense: true,
          leading: NetworkImageWithFallback(imageUrl: "https://tanum.projet.space/storage/${_entries[index]['image']}", fallback: (context, error, stackTrace) => const Icon(
            Icons.broken_image,
            size: 65,
          ),
            loadingBuilder: (context, child, progress) {
              if (progress == null) {
                return child;
              } else if (progress.cumulativeBytesLoaded ==
                  progress.expectedTotalBytes) {
                return child;
              } else {
                return SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                          : 0,
                    ),
                  ),
                );
              }
            },),
          title: Text(_entries[index]['title']),
          subtitle: Text("${date.year}-${date.month}-${date.day}"),
        );
      }, itemCount: _entries.length),
    );
  }
}
