import 'package:lab8_203843/change_theme.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;

class Album extends StatefulWidget {
  @override
  _AlbumState createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  File _image;
  final picker = ImagePicker();
  String _uploadFileURL;
  String _description;
  CollectionReference imgColRef;

  @override
  void initState() {
    imgColRef = FirebaseFirestore.instance.collection('imageURLs');
    super.initState();
  }

  //void dispose(){
  //  myController.dispose();
  //  super.dispose();
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Album'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text('Change theme'),
              ),
            ],
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btn1",
              child: Icon(Icons.add_a_photo),
              onPressed: () {
                chooseImage().whenComplete(() => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Confirm Upload ?'),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: _image != null
                                  ? Image.file(_image)
                                  : TextButton(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.blue,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        uploadFile();
                                      }),
                            ),
                            TextField(
                              onChanged: (value){
                                setState(() {
                                  _description = value;
                                });
                              },
                              decoration: InputDecoration(hintText:"Image Description"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                uploadFile();
                                Navigator.of(context).pop();
                              },
                              child: Text('Save'))
                        ],
                      ),
                    ));
              },
            ),
            FloatingActionButton(
              heroTag: "btn2",
              child: Icon(Icons.camera),
              onPressed: () {
                chooseImageCamera().whenComplete(() => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Confirm Upload ?'),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: _image != null
                                  ? Image.file(_image)
                                  : TextButton(
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.blue,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        uploadFile();
                                      }),
                            ),
                            TextField(
                              onChanged: (value){
                                setState(() {
                                  _description = value;
                                });
                              },
                              decoration: InputDecoration(hintText:"Image Description"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                uploadFile();
                                Navigator.of(context).pop();
                              },
                              child: Text('Save'))
                        ],
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: imgColRef.snapshots(includeMetadataChanges: true),
          builder: (context, snapshot) {
            if (snapshot.data?.docs == null || !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Hero(
              tag: 'imageHero',
              child: Container(
                child: StaggeredGridView.countBuilder(
                    itemCount: snapshot.data.docs.length,
                    crossAxisCount: 2,
                    itemBuilder: (context, index) => GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 0)),
                                ]),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: snapshot.data.docs[index].get('url'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            print('go to details');
                          },
                        ),
                    staggeredTileBuilder: (index) =>
                        StaggeredTile.count(1, index.isEven ? 1.2 : 1.8)),
              ),
            );
          },
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return NewTheme();
          }));
        break;

    }
  }

  Future chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });

    if (pickedFile.path == null) retrieveLostData();
  }

  Future chooseImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });

    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file.path);
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image.path)}');

    firebase_storage.UploadTask task = ref.putFile(_image);

    task.whenComplete(() async {
      print('File Uploaded');
      await ref.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadFileURL = fileURL;
        });
      }).whenComplete(() async {
        await imgColRef.add({'url': _uploadFileURL, 'description': _description});
        print('link added to database');
      });
    });
  }
}
