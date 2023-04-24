import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tanun_projet_space/components/UploadButton.dart';

class CreateDiary extends StatefulWidget {
  const CreateDiary({Key? key}) : super(key: key);

  @override
  State<CreateDiary> createState() => _CreateDiaryState();
}

class _CreateDiaryState extends State<CreateDiary> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  String? _fileName;
  File? _file;
  @override
  Widget build(BuildContext context) {
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
                  fileName: _fileName,
                  process: () async {
                    final picker = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );

                    if (picker != null) {

                      var result = picker.files.single;
                      setState(() {
                        _file = File(result.path!);
                        _fileName = result.name;
                      });
                    }
                  },
              ),
              SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }
}
