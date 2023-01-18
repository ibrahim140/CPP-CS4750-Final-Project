import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

/*
* Author: Mohammed Ibrahim
* Date: January 17, 2023
* Description: An app that can classify which breed a cat or dog belongs to.
* Version: 1.0.0
*/

void main() {
  runApp(const BreedDetect());
}

class BreedDetect extends StatefulWidget {
  const BreedDetect({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BreedDetectState();
  }
}

class _BreedDetectState extends State<BreedDetect> {

  final ImagePicker _picker = ImagePicker();
  Future<File>? file;
  File? _galleryImage;
  String imageResult = '';

  chooseImage(bool cam) async {
    if(!cam) {
      XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      _galleryImage = File(pickedImage!.path);
    }
    else {
      XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
      _galleryImage = File(pickedImage!.path);
    }
    setState(() {
      _galleryImage;
      classifyBreed();
    });
  }

  Future initializeTensorFlowModel()async{
    Tflite.close();
    String? model = await Tflite.loadModel(
      model: "assets/Cats_and_Dogs_Model.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  classifyBreed()async{
    var breed = await Tflite.runModelOnImage(
      path: _galleryImage!.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.40,
      asynch: true,
    );
    setState(() {imageResult = '';});

    for(var i in breed!){
      setState(() {
        imageResult += "${"\n" + i["label"]}\n";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeTensorFlowModel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Breed Classifier'),
        ),
        body: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child:
                IconButton(
                  icon: const Icon(Icons.image_rounded),
                  onPressed: () {
                    chooseImage(false);
                  },
                ),
              ),
              Expanded(
                child:
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    chooseImage(true);
                  },
                ),
              ),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _galleryImage == null? Container() : Image.file(_galleryImage!,
                  height: 360.0, width: 380.0,
                ),
              ]),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  color: Colors.white,
                  height: 100,
                  child: Center(child: Text(imageResult,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}