
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class VendorController{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


//FUNCTION TO UPLOAD IMAGE TO STORAGE
  _uploadVendorImageToStorage(Uint8List? image) async{
    Reference ref = _storage.ref().child('storeImages').child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

//FUNCTION TO STORE ALL THE DATA TO CLOUD FIRESTORE



//FUNCTION TO PICK IMAGE 
  pickStoreImage(ImageSource source) async{
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if(_file != null){
      return await _file.readAsBytes();
    }else{
      print("No Image Selected");
    }
  }

//FUNCTION TO SAVE VENDORS DATA
  Future<String> registerVendor (
    String businessName, 
    String email, 
    String phoneNum, 
    String countryValue, 
    String stateValue, 
    String cityValue, 
    String taxRegistered, 
    String taxNumber, 
    Uint8List? image
    ) async{
      String res = "Some error occured";
      try{
          String storeImage = await _uploadVendorImageToStorage(image);

          await _firestore
          .collection("vendors")
          .doc(_auth.currentUser!.uid)
          .set({
            'businessName': businessName,
            'email': email,
            'phoneNum': phoneNum,
            'countryValue': countryValue,
            'stateValue': stateValue,
            'cityValue': cityValue,
            'taxRegistered': taxRegistered,
            'taxNumber': taxNumber,
            'storeImage': storeImage,
            'approved': false,
            'vendorId': _auth.currentUser!.uid,
          });
      }catch(e){
        res = e.toString();
      }

      return res;
    }
}