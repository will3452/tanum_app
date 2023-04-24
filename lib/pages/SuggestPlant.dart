
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tanun_projet_space/components/Loader.dart';
import 'package:tanun_projet_space/components/UploadButton.dart';
import 'package:tanun_projet_space/utils/http.dart';

import '../utils/storage.dart';

class SuggessPlant extends StatefulWidget {
  const SuggessPlant({Key? key}) : super(key: key);

  @override
  State<SuggessPlant> createState() => _SuggessPlantState();
}

class _SuggessPlantState extends State<SuggessPlant> {
  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantScienceController = TextEditingController();
  File? _selectedFile;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  String? _fileName;

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
          "common_name": _plantNameController.text,
          "scientific_name": _plantScienceController.text
        }
      );



      try {

        var response = await dio.post('/api/suggested-plants', data: fd);
        print("response >> $response");
      } on DioError catch (e) {
        print("error >> $e");
        print("error response >> ${e.response}");
      }

       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Suggested plant has been submitted to the server"))
      );

      _formKey.currentState?.reset();
      _plantScienceController.text = '';
      _plantNameController.text = '';

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
        title: const Text("Suggest Plant"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _plantNameController,
                decoration: const InputDecoration(
                  label: Text('Common Name'),
                  hintText: "Enter Plant Name",
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
                controller: _plantScienceController,
                decoration: const InputDecoration(
                  label: Text('Scientific Name'),
                  hintText: "Enter Scientific Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  prefixIcon: Icon(Icons.science),
                ),
                validator: (value) {
                  if (value == '' || value == null) {
                    return "this field is required.";
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              UploadButton(process: () {
                _selectFile();
              },fileName: _fileName,),
              const SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _selectedFile != null) {
                        _submit();
                      }
                    },
                    child: Text('Submit'),
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
