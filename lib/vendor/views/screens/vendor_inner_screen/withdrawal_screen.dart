import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class WithDrawalScreen extends StatelessWidget {
  late String amount;

  late String name;

  late String mobile;

  late String bankName;

  late String accountNum;

  late String holderName;

  late String ifsc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
        title: Text(
          "WITHDRAW EARNINGS",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Amount cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    name = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Mobile no. cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    mobile = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Mobile No.',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Bank Name cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    bankName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Account number cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    accountNum = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Bank Account Number',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Holder's name cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    holderName = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Account Holder's Name",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "IFSC cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    ifsc = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'IFSC Code',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _firestore
                          .collection('withdrawal')
                          .doc(Uuid().v4())
                          .set({
                        'Amount': amount,
                        " Name": name,
                        'Mobile': mobile,
                        'BankName': bankName,
                        'BankAccountName': accountNum,
                        "BankAccountNumber": holderName,
                        "ifsc": ifsc,
                      });
                      print("cool");
                    } else {
                      print("false");
                    }
                  },
                  child: Text(
                    "GET CASH",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
