import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rebooked_app/provider/product_provider.dart';
import 'package:uuid/uuid.dart';

class ImagesTabScreen extends StatefulWidget {
  @override
  State<ImagesTabScreen> createState() => _ImagesTabScreenState();
}

class _ImagesTabScreenState extends State<ImagesTabScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
  final ImagePicker picker = new ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<File> _image = [];
  List<String> _imageUrlList = [];

  chooseImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile == null){
      print("No image is picked");  
    }else{
      setState(() {
        _image.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider = Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            child: Text(
              "Upload Book Images",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              childAspectRatio: 3/3,
            ), 
            shrinkWrap: true,
            itemCount: _image.length+1,
            itemBuilder:(context, index) {
              return index == 0
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(255, 182, 182, 182),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed:() {
                          chooseImage();
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                  ),
                ) :
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          _image[index-1],
                        ),
                      ),
                    ), 
                  ),
                );
            },
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () async{
              EasyLoading.show(status: 'Saving Images');
              for(var img in _image){
                Reference ref = _storage.ref().child('productImage').child(Uuid().v4());

                await ref.putFile(img).whenComplete(() async{
                  await ref.getDownloadURL().then((value) {
                    setState(() {
                      _imageUrlList.add(value);
                    });
                    print("complete");
                  });
                });
              }
              setState(() {
                _productProvider.getFormData(imageUrlList: _imageUrlList);
                print("Saved");
                EasyLoading.dismiss();
              });
            }, 
            child: !_image.isEmpty? Text("UPLOAD"): Text(""),
          ),
        ],
      ),
    );
  }
}