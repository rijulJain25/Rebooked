import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/widgets/banner_widgets.dart';


class UploadScreen extends StatefulWidget {
  static const String routeName = '\UploadScreen';

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _image;
  String? filename;

  pickImage() async{
    FilePickerResult? result = await FilePicker.platform
    .pickFiles(allowMultiple: false, type: FileType.image);

    if(result != null){
      setState(() {
        _image= result.files.first.bytes;

        filename= result.files.first.name;
      });
    }
  }


//used for uploading banners in storage
  _uploadBannersToStorage(dynamic image) async{
    Reference ref = _storage.ref().child('Banners').child(filename!);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

// now uploading that stored image to cloud Firestone
  _uploadToFireStore() async{
    EasyLoading.show();
    if(_image != null){
      String imgURL = await _uploadBannersToStorage(_image);
      await _firestore.collection('Banners').doc(filename).set({
        'image': imgURL,
      }).whenComplete(() {
        EasyLoading.dismiss();
        setState(() {
          _image = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Banners",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),

          Divider(
            color: Colors.grey,
          ),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        border: Border.all(color: Colors.grey.shade800),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _image != null ? 
                      Image.memory(
                        _image,
                        fit:BoxFit.fill,
                        ) : Center(
                        child: Text('Banners'),
                      ),
                    ),
                    
                    SizedBox(
                      height: 30,
                    ),

                    

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow.shade900
                      ),
                      onPressed: (){
                        pickImage();
                      }, 
                      child: Text("Upload Image"),
                    ),
                  ],
                ),
              ),
              
              SizedBox(
                width: 30,
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow.shade900
                ),
                onPressed: (){
                  _uploadToFireStore();
                }, 
                child: Text("Save"),
              ),
            ],
          ),

          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Banners',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            BannerWidget(),
        ],
      ),
    );
  }
}