import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter_camera_task3/screens/gallery.dart';
import 'package:path_provider/path_provider.dart';

ValueNotifier<List<File>> images = ValueNotifier([]);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CameraDescription> availablecameras = [];

  CameraController? cameraController;
  File? latestimg;

  @override
  void initState() {
    _initializeCamera().then((_) {
      // Only proceed with loading images and camera use once the camera is initialized
      _loadImages();
    });
    super.initState();
  }

  @override
  void dispose() {
    cameraController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: (cameraController == null ||
              cameraController!.value.isInitialized == false)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 600,
                  width: double.infinity,
                  child: CameraPreview(cameraController!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundImage: latestimg == null
                          ? AssetImage('assets/lufy.jpg')
                          : FileImage(latestimg!),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GalleryScreeen(),
                              ));
                        },
                      ),
                      radius: 30,
                    ),
                    IconButton(
                        iconSize: 65,
                        onPressed: () {
                          _takePicture();
                        },
                        icon: Icon(Icons.camera)),
                    SizedBox(
                      width: 60,
                    )
                  ],
                )
              ],
            ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      availablecameras = await availableCameras();
      if (availablecameras.isNotEmpty) {
        setState(() {
          cameraController =
              CameraController(availablecameras.first, ResolutionPreset.high);
        });
        await cameraController!.initialize();
        if (!mounted) return;
        setState(() {});
      } else {
        print("No available cameras found.");
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  Future<void> _takePicture() async {
    try {
      if (cameraController == null || !cameraController!.value.isInitialized) {
        print("Camera is not initialized yet.");
        return; // Prevent taking picture if camera is not initialized
      }

      XFile picture = await cameraController!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final path =
          "${directory.path}/${DateTime.now().microsecondsSinceEpoch}.jpg";

      final image = await File(picture.path);

      // Ensure the file exists and is not empty
      if (await image.exists() && await image.length() > 0) {
        await image.copy(path);
        setState(() {
          latestimg = image;
        });

        images.value.insert(0, image);
        images.notifyListeners();
      } else {
        print("Error: The image file is empty or doesn't exist at path: $path");
      }
    } catch (e) {
      print('error taking picture :$e');
    }
  }

  Future<void> _loadImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final img = directory.listSync().whereType<File>().toList();

      img.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      // images.value = [...images.value, ...img];
      images.value = img;
    } catch (e) {
      print('Error LOading IMagess: $e');
    }
  }
}
