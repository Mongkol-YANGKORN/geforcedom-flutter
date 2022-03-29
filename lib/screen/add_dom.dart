import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geforcedom/components/round_buttom.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddDomScreen extends StatefulWidget {
  const AddDomScreen({Key? key}) : super(key: key);

  @override
  State<AddDomScreen> createState() => _AddDomScreenState();
}

class _AddDomScreenState extends State<AddDomScreen> {
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.reference().child('Posts');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  File? _image;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  // TextEditingController latitudeController = TextEditingController();
  // TextEditingController longitudeController = TextEditingController();

  final picker = ImagePicker();

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image selected');
      }
    });
  }

  Future getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image selected');
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Dom"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  dialog(context);
                },
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: _image != null
                        ? ClipRect(
                            child: Image.file(
                              _image!.absolute,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 238, 238, 238),
                                borderRadius: BorderRadius.circular(10)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name of dom",
                      hintText: 'Enter name of dom',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Detail",
                      hintText: 'Enter detail of dom',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: locationController,
                    keyboardType: TextInputType.text,
                    // minLines: 1,
                    // maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Dom Location",
                      hintText: 'Enter detail of dom location',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.text,
                    // minLines: 1,
                    // maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Price of Dom",
                      hintText: 'Enter detail price of dom.',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // TextFormField(
                  //   controller: latitudeController,
                  //   keyboardType: TextInputType.text,
                  //   // minLines: 1,
                  //   // maxLines: 5,
                  //   decoration: InputDecoration(
                  //     labelText: "Latitude",
                  //     hintText: 'Enter latitude.',
                  //     border: OutlineInputBorder(),
                  //     hintStyle: TextStyle(color: Colors.grey),
                  //     labelStyle: TextStyle(color: Colors.black),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  // TextFormField(
                  //   controller: longitudeController,
                  //   keyboardType: TextInputType.text,
                  //   // minLines: 1,
                  //   // maxLines: 5,
                  //   decoration: InputDecoration(
                  //     labelText: "longitude",
                  //     hintText: 'Enter longitude.',
                  //     border: OutlineInputBorder(),
                  //     hintStyle: TextStyle(color: Colors.grey),
                  //     labelStyle: TextStyle(color: Colors.black),
                  //   ),
                  // ),
                ],
              )),
              SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: 'Uplode',
                  onpress: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      int date = DateTime.now().microsecondsSinceEpoch;
                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref('/domPic$date');
                      UploadTask uploadTask = ref.putFile(_image!.absolute);
                      await Future.value(uploadTask);
                      var newUrl = await ref.getDownloadURL();

                      final User? user = _auth.currentUser;
                      postRef.child('Dom List').child(date.toString()).set({
                        'pId': date.toString(),
                        'pImage': newUrl.toString(),
                        'pTime': date.toString(),
                        'pTitle': titleController.text.toString(),
                        'pDescription': descriptionController.text.toString(),
                        'pLocation': locationController.text.toString(),
                        'pPrice': priceController.text.toString(),
                        // 'pLatitude': latitudeController.text.toString(),
                        // 'pLongitude': longitudeController.text.toString(),
                        'uEmail': user!.email.toString(),
                        'uid': user!.uid.toString(),
                      }).then((value) {
                        toastMessage('Dom published');
                        setState(() {
                          showSpinner = false;
                        });
                      }).onError((error, stackTrace) {
                        toastMessage(error.toString());
                      });
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      toastMessage(e.toString());
                    }
                  }),
            ],
          ),
        )),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
