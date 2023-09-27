import 'dart:typed_data';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/vendor_register_controller.dart';

class VendorRegistrationScreen extends StatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VendorController _vendorController = VendorController();

  late String countryValue;
  late String stateValue;
  late String cityValue;
  late String businessName;
  late String email;
  late String phoneNum;
  late String taxNumber;

  Uint8List? _image;

  selectedGalleryImage() async{
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.gallery);

    setState(() {
      _image= im;
    });
  }

  String ? _taxStatus;

  List<String> _taxOption = [
    "YES", 
    "NO",
  ];

  _saveVendorDetail() async{
    EasyLoading.show(status: "PLEASE WAIT");    
    if(_formKey.currentState!.validate()){
      await _vendorController.registerVendor(
        businessName, 
        email, 
        phoneNum, 
        countryValue, 
        stateValue, 
        cityValue, 
        _taxStatus!, 
        taxNumber, 
        _image
      ).whenComplete(() {
        EasyLoading.dismiss();

        setState(() {
          _formKey.currentState!.reset();
          _image = null;
        });
      });
    }else{
      EasyLoading.dismiss();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.yellow.shade800, Colors.yellow])),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ), 
                            child: _image == null ? IconButton(
                              onPressed: () {
                                selectedGalleryImage();
                              },
                              icon: Icon(CupertinoIcons.photo),
                            ): Image.memory(_image!),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged:(value) {
                        businessName = value;
                      },
                      validator:(value) {
                        if(value!.isEmpty){
                          return "Business Name cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Business Name",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged:(value) {
                        email = value;
                      },
                      validator:(value) {
                        if(value!.isEmpty){
                          return "Email cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged:(value) {
                        phoneNum = value;
                      },
                      validator:(value) {
                        if(value!.isEmpty){
                          return "Phone number cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                    ),
                    
              
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "GST Registered?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    
                          Flexible(
                            child: Container(
                              width: 120,
                              child: DropdownButtonFormField(
                                hint: Text("Select"),
                                items: _taxOption.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(), 
                                onChanged: (value){
                                  setState(() {
                                    _taxStatus = value;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
              
                    if(_taxStatus == "YES")
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: TextFormField(
                          onChanged:(value) {
                            taxNumber = value;
                          },
                          validator:(value) {
                            if(value!.isEmpty){
                              return "GST Number cannot be empty";
                            }else{
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "GST Number",
                          ),
                        ),
                      ),
              
              
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: InkWell(
                        onTap: (){
                          _saveVendorDetail();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width-40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                      
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}




//businessName, email, phoneNum, countryValue, stateValue, cityValue, _taxStatus!, taxNumber