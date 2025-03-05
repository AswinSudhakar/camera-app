import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera_task3/homescreen.dart';
import 'package:flutter_camera_task3/screens/details.dart';
import 'package:path_provider/path_provider.dart';

class GalleryScreeen extends StatelessWidget {
  const GalleryScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  clearAllImages();
                },
                icon: Icon(Icons.delete_forever))
          ],
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            'Gallery',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar:
            BottomNavigationBar(backgroundColor: Colors.blue, items: [
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.photo_album),
            ),
            label: 'gallery',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                },
                icon: Icon(Icons.camera)),
            label: 'camera',
          )
        ]),
        body: images.value.isEmpty
            ? Center(
                child: Text(
                  'Gallery Is Empty!',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              )
            : ValueListenableBuilder(
                valueListenable: images,
                builder: (context, value, child) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6),
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      final file = value[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return DetailPage(
                                index: index,
                              );
                            },
                          ));
                        },
                        child: Card(
                          shadowColor: const Color.fromARGB(255, 101, 91, 91),
                          elevation: 30,
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ));
  }

  Future<void> clearAllImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final files = directory.listSync();

      for (var file in files) {
        if (file is File) {
          await file.delete();
          print('Deleted: ${file.path}');
        }
      }

      images.value = [];

      images.notifyListeners();

      print('All images deleted and ValueNotifier list cleared.');
    } catch (e) {
      print('Error clearing images: $e');
    }
  }
}
