import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final File imageFile;
  const ImagePreview({required this.imageFile, super.key});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.imageFile.path);
    return Scaffold(
      backgroundColor:Colors.black,
      appBar:AppBar(
         backgroundColor:const Color.fromARGB(255, 56, 72, 85),
      ) ,
      body: SafeArea(
          child: Column(
        children: [
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: IconButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       icon:const Icon(
            //         Icons.arrow_back,
            //         color: Colors.black,
            //       )),
            // ),
            
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Container(height: 600, child: Image.file(picture)),
            ),
          ),
          
        ],
      )),
    );
  }
}
