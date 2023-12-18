import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_license_plate/constant/route.dart';

import '../../services/firestore_services_new.dart';
import '../../utilities/dialogs/error_dialog.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  User? user;
  String? uid;
  File? imageFile;
  bool isCameraSelected = true;
  String ocrResult = '';
  bool? isResultInDatabase;
  bool isResultLoading = false;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan View'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            title: const Text('Choose Image From'),
                            children: [
                              SimpleDialogOption(
                                child: const Text('Camera'),
                                onPressed: () async {
                                  await _imgFromCamera();
                                  Navigator.pop(context);
                                },
                              ),
                              SimpleDialogOption(
                                child: const Text('Gallery'),
                                onPressed: () async {
                                  await _imgFromGallery();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Take Photo'),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(
                          () {
                            isResultLoading = true;
                          },
                        );
                        try {
                          await _scanImageFlask();
                          if (ocrResult != '') {
                            var checker = await resultChecker(
                                uid: uid!, result: ocrResult);
                            setState(
                              () {
                                isResultInDatabase = checker;
                              },
                            );
                          }
                        } finally {
                          setState(
                            () {
                              isResultLoading = false;
                            },
                          );
                        }
                      },
                      child: isResultLoading
                          ? SizedBox(
                              width: 15,
                              height: 15,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Scan photo')),
                  ElevatedButton(
                    onPressed: () async {
                      await _scanImageMlkit();
                      if (ocrResult != '') {
                        var checker =
                            await resultChecker(uid: uid!, result: ocrResult);
                        setState(
                          () {
                            isResultInDatabase = checker;
                          },
                        );
                      }
                    },
                    child: const Text('Scan Photo Offline'),
                  ),
                ],
              ),
              imageFile == null
                  ? const Text('\nNo photo selected yet')
                  : Image.file(
                      imageFile!,
                    ),
              const SizedBox(
                height: 20.0,
              ),
              Text(ocrResult),
              ocrResult == ''
                  ? const SizedBox(
                      height: 20.0,
                    )
                  : isResultInDatabase == false
                      ? ElevatedButton(
                          onPressed: () async {
                            if (user != null) {
                              final uid = user!.uid;
                              await createResult(
                                  uid: uid, textResult: ocrResult);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  plateRoute, (route) => false);
                            }
                          },
                          child: const Text('Enter Parking'),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (user != null) {
                              final uid = user!.uid;
                              await deleteResult(
                                  uid: uid, textResult: ocrResult);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  plateRoute, (route) => false);
                            }
                          },
                          child: const Text('Exit Parking'),
                        )
            ],
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  _imgFromGallery() async {
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 50).then(
      (value) {
        if (value != null) {
          _cropImage(File(value.path));
        }
      },
    );
  }

  _imgFromCamera() async {
    await picker.pickImage(source: ImageSource.camera, imageQuality: 50).then(
      (value) {
        if (value != null) {
          _cropImage(File(value.path));
        }
      },
    );
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Image Cropper",
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: "Image Cropper",
        )
      ],
    );

    if (croppedFile != null) {
      imageCache.clear();
      setState(
        () {
          imageFile = File(croppedFile.path);
        },
      );
      // reload();
    }
  }

  Future<void> _scanImageFlask() async {
    if (imageFile == null) {
      return await showErrorDialog(context, 'No photo yet, can not scan');
    }
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://ikmalfaris50.pythonanywhere.com/'));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile!.path));
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.toBytes();
        var resultJson = json.decode(utf8.decode(responseBody));
        var resultText = resultJson['result'];
        setState(
          () {
            ocrResult = resultText;
          },
        );
        print(resultText);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  Future<void> _scanImageMlkit() async {
    if (imageFile == null) {
      return await showErrorDialog(context, 'No photo yet, can not scan');
    }
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFile(imageFile!);
    final resultText = await textRecognizer.processImage(inputImage);
    setState(
      () {
        ocrResult = resultText.text;
      },
    );
  }
}
