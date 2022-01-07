import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';

class Secondpage extends StatefulWidget {
  @override
  _SecondpageState createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<Uint8List> image = [];
  var pageformat = "A4";
  File? _image;
  Uint8List? _byte, salida;
  String _versionOpenCV = 'OpenCV';
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    _getOpenCVVersion();
  }

  testOpenCV({
    required String pathString,
    required CVPathFrom pathFrom,
    required double thresholdValue,
    required double maxThresholdValue,
    required int thresholdType,
  }) async {
    try {
      _byte = await Cv2.threshold(
        pathFrom: pathFrom,
        pathString: pathString,
        maxThresholdValue: maxThresholdValue,
        thresholdType: thresholdType,
        thresholdValue: thresholdValue,
      );

      setState(() async {
        _byte;
        image.add(_byte!);
        _visible = false;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _getOpenCVVersion() async {
    String? versionOpenCV = await Cv2.version();
    setState(() {
      _versionOpenCV = 'OpenCV: ' + versionOpenCV!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          image.length == 0
              ? Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Select Image From Camera or Gallary',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.indigo[900],
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : PdfPreview(
                  maxPageWidth: 1000,
                  canChangeOrientation: true,
                  canDebug: false,
                  build: (format) => generateDocument(
                    format,
                    image.length,
                    image,
                  ),
                ),
          Align(
            alignment: Alignment(-0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.image,
              ),
              backgroundColor: Colors.indigo[900],
              onPressed: getImageFromGallery,
            ),
          ),
          Align(
            alignment: Alignment(0.5, 0.8),
            child: FloatingActionButton(
              elevation: 0.0,
              child: new Icon(
                Icons.camera,
              ),
              backgroundColor: Colors.indigo[900],
              onPressed: getImageFromcamera,
            ),
          ),
        ],
      ),
    );
  }

  getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    _image = File(pickedFile!.path);

    setState(() {
      if (pickedFile != null) {
        print('image picked hui hai');
        testOpenCV(
          pathFrom: CVPathFrom.GALLERY_CAMERA,
          pathString: _image!.path,
          thresholdValue: 130,
          maxThresholdValue: 200,
          thresholdType: Cv2.THRESH_BINARY,
        );
      } else {
        print('No image selected');
      }
    });
  }

  getImageFromcamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    setState(() {
      if (pickedFile != null) {
        testOpenCV(
          pathFrom: CVPathFrom.GALLERY_CAMERA,
          pathString: _image!.path,
          thresholdValue: 130,
          maxThresholdValue: 200,
          thresholdType: Cv2.THRESH_BINARY,
        );

        setState(() {
          _visible = true;
        });
      } else {
        print('No image selected');
      }
    });
  }

  Future<Uint8List> generateDocument(
      PdfPageFormat format, imagelenght, image) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    for (var im in image) {
      final showimage = pw.MemoryImage(im);

      doc.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: format.copyWith(
              marginBottom: 0,
              marginLeft: 0,
              marginRight: 0,
              marginTop: 0,
            ),
            orientation: pw.PageOrientation.portrait,
            theme: pw.ThemeData.withFont(
              base: font1,
              bold: font2,
            ),
          ),
          build: (context) {
            return pw.Center(
              child: pw.Image(showimage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    return await doc.save();
  }
}