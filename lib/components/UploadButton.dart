import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  final VoidCallback process;
  final String? fileName;

  const UploadButton({Key? key, this.fileName, required this.process}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: process,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.black12,
          padding: EdgeInsets.all(15),
          height: 75,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.upload),
                  Text("Upload Image", style: TextStyle(
                      fontSize: 20
                  ),)
                ],
              ),
              Text(fileName ?? 'Please choose file', overflow: TextOverflow.ellipsis,)
            ],
          ),
        ),
      ),
    );
  }
}
