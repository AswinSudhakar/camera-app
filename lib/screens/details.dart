import 'package:flutter/material.dart';
import 'package:flutter_camera_task3/homescreen.dart';
import 'package:share_plus/share_plus.dart';

class DetailPage extends StatelessWidget {
  final index;
  DetailPage({super.key, required this.index});

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
                  delete(index);
                  Navigator.pop(context);
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
        child: Image.file(images.value[index]),
      ),
    );
  }

  Future<void> delete(int index) async {
    images.value[index].delete();
    images.value.removeAt(index);
    images.notifyListeners();
  }
}
