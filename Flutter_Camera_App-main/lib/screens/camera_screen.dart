import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/screens/gallery_screen.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    super.initState();
  }

  late CameraController _controller; //To control the camera
  late Future<void>
      _initializeControllerFuture; // Future to wait until camera initializes
  int selectedCamera = 0;
  List<File> capturedImages = [];

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // if the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                return const Center(
                  // Otherwise, display a loading indicator.
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Camera switch button
                IconButton(
                  onPressed: () {
                    if (widget.cameras.length > 1) {
                      setState(() {
                        // selectedCamera = selectedCamera == 0 ? 1 : 0;
                        initializeCamera(selectedCamera);
                        // switch camera
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No secondary camera found'),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  icon: const Icon(
                    Icons.flip_camera_android_rounded,size: 35,
                    color: Colors.white,
                  ),
                ),
                // Capture button
                GestureDetector(
                  onTap: () async {
                    await _initializeControllerFuture; // To make sure camera is initialized
                    var xFile = await _controller.takePicture();
                    setState(() {
                      capturedImages.add(File(xFile.path));
                    });
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                     
                      border: Border.all(width: 5,color: Color.fromARGB(255, 58, 54, 54)),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                // Gallery button
                GestureDetector(
                  onTap: () {
                    if (capturedImages.isEmpty) return;
                    // Return if no image
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryScreen(
                                images: capturedImages.reversed.toList())));
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white,),
                      image: capturedImages.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(capturedImages.last),
                              fit: BoxFit.cover)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
