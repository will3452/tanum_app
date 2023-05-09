import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:tanun_projet_space/components/UploadButton.dart';

import '../components/Loader.dart';
import '../utils/http.dart';
import '../utils/storage.dart';

class CreateDiary extends StatefulWidget {
  const CreateDiary({Key? key}) : super(key: key);

  @override
  State<CreateDiary> createState() => _CreateDiaryState();
}

class _CreateDiaryState extends State<CreateDiary> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _fileName;
  File? _selectedFile;
  bool _loading = false;

  void _selectFile() async {
    try {
      final file = await FilePicker.platform.pickFiles(type: FileType.image);
      if (file != null) {
        final result = file.files!.single;

        setState(() {
          _selectedFile = File(result.path!);
          _fileName = result.name!;
        });

        print("path ${result.path!}");
      } else {
        print('failed');
      }
    } on PlatformException catch (e) {
      print('Unsupported operation $e');
    } catch (e) {
      print('error >> $e');
    }
  }

  void _submit () async {
    try {
      setState(() {
        _loading = true;
      });

      dio.options.headers['authorization'] = 'Bearer ${box.read('userToken')}';
      dio.options.headers['Accept'] = 'application/json';

      FormData fd = FormData.fromMap(
          {
            "image": await MultipartFile.fromFile(_selectedFile!.path, filename: _fileName),
            "title": _titleController.text,
            "body": _bodyController.text
          }
      );



      try {

        var response = await dio.post('/api/diary', data: fd);
        print("response >> $response");
      } on DioError catch (e) {
        print("error >> $e");
        print("error response >> ${e.response}");
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Diary has been added!"))
      );

      _formKey.currentState?.reset();
      _titleController.text = '';
      _bodyController.text = '';

      setState(() {
        _loading = false;
        _fileName = '';
      });
    } catch (e) {
      print("submit $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Loader(),
        backgroundColor: Color(0xFFf1f2f3),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("New Entry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              UploadButton(
                  fileName: _fileName??'',
                  process: () async {
                    _selectFile();
                  },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  label: Text('Title'),
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  prefixIcon: Icon(Icons.text_fields),
                ),
                validator: (value) {
                  if (value == '') {
                    return "this field is required.";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _bodyController,
                maxLines: null,
                decoration: const InputDecoration(
                  label: Text('Body'),
                  hintText: "Body",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  prefixIcon: Icon(Icons.text_fields),
                ),
                validator: (value) {
                  if (value == '') {
                    return "this field is required.";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if ( _selectedFile != null) {
                        _submit();
                      }

                      print('preseed!');
                    },
                    child: const Text('Submit'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
