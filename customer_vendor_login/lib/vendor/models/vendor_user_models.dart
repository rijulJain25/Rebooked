class VendorUserModel{
  
  final bool? approved;

  final String? businessName;
  final String? cityValue;
  final String? countryValue;
  final String? email;
  final String? phoneNum;
  final String? stateValue;
  final String? storeImage;
  final String? taxNumber;
  final String? taxRegistered;
  final String? vendorId;

  VendorUserModel({
    required this.approved,
    required this.vendorId,
    required this.businessName,
    required this.cityValue,
    required this.countryValue,
    required this.email,
    required this.phoneNum,
    required this.stateValue,
    required this.storeImage,
    required this.taxNumber,
    required this.taxRegistered
  });

  VendorUserModel.fromJson(Map<String, Object?> json):this(
    approved: json['approved']! as bool,
    vendorId: json['vendorId']! as String,
    businessName: json['businessName']! as String,
    cityValue: json['cityValue']! as String,
    countryValue: json['countryValue']! as String,
    email: json['email']! as String,
    phoneNum: json['phoneNum']! as String,
    stateValue: json['stateValue']! as String,
    storeImage: json['storeImage']! as String,
    taxNumber: json['taxNumber']! as String,
    taxRegistered: json['taxRegistered']! as String,
  );

  Map<String, Object?> toJson(){
    return {
      'approved': approved,
      'vendorId': vendorId,
      'businessName': businessName,
      'cityValue': cityValue,
      'countryValue': countryValue,
      'email': email,
      'phoneNum': phoneNum,
      'stateValue': stateValue,
      'storeImage': storeImage,
      'taxNumber': taxNumber,
      'taxRegistered': taxRegistered, 
    };
  }
}