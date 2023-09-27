import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rebooked_web_admin/views/screens/side_bar_screens/widgets/category_widget.dart';


class CategoryScreen extends StatefulWidget {
  static const String routeName = '\CategoryScreen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  dynamic _image;

  String? filename;

  late String categoryName;

  _pickImage() async{
    FilePickerResult? result = await FilePicker.platform
    .pickFiles(allowMultiple: false, type: FileType.image);

    if(result != null){
      setState(() {
        _image= result.files.first.bytes;

        filename= result.files.first.name;
      });
    }
  }

  _uploadCategoryBannerToStorage(image) async{
    Reference ref = _storage.ref().child('categoryImages').child(filename!);

    UploadTask uploadTask = ref.putData(image);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadCategory() async{
    EasyLoading.show();
    if(_formKey.currentState!.validate()){
      String imageUrl = await _uploadCategoryBannerToStorage(_image);
      await _firestore.collection('categories').doc(filename).set({
        "image": imageUrl,
        "categoryName": categoryName,
      }).whenComplete((){
        EasyLoading.dismiss();
        setState(() {
          _image= null;
          _formKey.currentState!.reset();
        });
      });
    }else{
      print("Oh Bad Guy");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Categories",
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
                        fit:BoxFit.cover,
                        ) : Center(
                          child: Text('Category'),
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
                          _pickImage();
                        }, 
                        child: Text("Upload Image"),
                      ),
                    ],
                  ),
                ),
                
                Flexible(
                  child: SizedBox(
                    width: 190,
                    child: TextFormField(
                      onChanged: (value) {
                        categoryName= value;
                      },
                      validator: (value) {
                        if(value!.isEmpty){
                          return "Category name must not be  empty!";
                        }else{
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Enter Category Name",
                        hintText: "Enter Category Name",
                      ),
                    ),
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
                    uploadCategory();
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
                  'Categories',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            CategoryWidget(),
          ],
        ),
      ),
    );
  }
}