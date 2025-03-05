import 'package:flutter/material.dart';
import 'package:flutter_camera_task3/homescreen.dart';

import 'package:flutter_camera_task3/screens/gallery.dart';
import 'package:share_plus/share_plus.dart';

class DetailPage extends StatelessWidget {
  final index;
  const DetailPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                iconSize: 40,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(images.value[index].toString())));
                },
                icon: Icon(Icons.info)),
            IconButton(
                iconSize: 40,
                onPressed: () {
                  _showConfirmationDialog(context);
                  // Navigator.pop(context);
                },
                icon: Icon(Icons.delete)),
            IconButton(
                iconSize: 40,
                onPressed: () async {
                  final xfileimg = XFile(images.value[index].path);
                  await Share.shareXFiles(
                    [xfileimg],
                  );
                },
                icon: Icon(Icons.share)),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Image.file(
          images.value[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Do you want to proceed?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                print("Cancel pressed");
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GalleryScreeen(),
                    ));
                delete(index);
                print("Confirm pressed");
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> delete(int index) async {
    images.value[index].delete();
    images.value.removeAt(index);
    images.notifyListeners();
  }
}
