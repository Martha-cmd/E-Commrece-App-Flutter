class UserModel {
  final String buyerId;
  final String fullName;
  final String email;
  final String address;
  final String phoneNumber;
  final String profileImage;
  final DateTime lastActive;
  final bool isOnline;

  const UserModel({
    required this.fullName,
    required this.address,
    required this.phoneNumber,
    required this.profileImage,
    required this.lastActive,
    required this.buyerId,
    required this.email,
    this.isOnline = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(
        buyerId: json['buyerId'].toString(),
        address: json['address'].toString(),
        fullName: json['fullName'].toString(),
        profileImage: json['profileImage'].toString(),
        email: json['email'].toString(),
        phoneNumber: json['phoneNumber'].toString(),
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
      );

  Map<String, dynamic> toJson() => {
        'buyerId': buyerId,
        'address': address,
        'fullName': fullName,
        'profileImage': profileImage,
        'email': email,
        'phoneNumber': phoneNumber,
        'isOnline': isOnline,
        'lastActive': lastActive,
      };
}


class VendorModel {
  final String approved;
  final String bussinessName;
  final String cityValue;
  final String countryValue;
  final String email;
  final String phoneNumber;
  final String stateValue;
  final String storeImage;
  final String vendorId;
  final DateTime lastActive;
  final bool isOnline;

  const VendorModel({
    required this.approved,
    required this.bussinessName,
    required this.cityValue,
    required this.countryValue,
    required this.email,
    required this.phoneNumber,
    required this.stateValue,
    required this.storeImage,
    required this.vendorId,
    required this.lastActive,
    this.isOnline = false,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      VendorModel(
        approved: json['approved'].toString(),
        bussinessName: json['bussinessName'].toString(),
        cityValue: json['cityValue'].toString(),
        countryValue: json['countryValue'].toString(),
        email: json['email'].toString(),
        phoneNumber: json['phoneNumber'].toString(),
        stateValue: json['stateValue'].toString(),
        storeImage: json['storeImage'].toString(),
        vendorId: json['vendorId'].toString(),
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
      );

  Map<String, dynamic> toJson() => {
    'approved': approved,
    'bussinessName': bussinessName,
    'cityValue': cityValue,
    'countryValue': countryValue,
    'email': email,
    'phoneNumber': phoneNumber,
    'stateValue': stateValue,
    'storeImage': storeImage,
    'vendorId': vendorId,
    'isOnline': isOnline,
    'lastActive': lastActive,
  };
}



class vUserModel {
  final String Id;
  final String name;
  final String email;
  final String address;
  final String phoneNumber;
  final String image;
  final DateTime lastActive;
  final bool isOnline;

  const vUserModel({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.image,
    required this.lastActive,
    required this.Id,
    required this.email,
    this.isOnline = false,
  });

  factory vUserModel.fromJson(Map<String, dynamic> json) =>
      vUserModel(
        Id: json['id'].toString(),
        address: json['address'].toString(),
        name: json['name'].toString(),
        image: json['image'].toString(),
        email: json['email'].toString(),
        phoneNumber: json['phoneNumber'].toString(),
        isOnline: json['isOnline'] ?? false,
        lastActive: json['lastActive'].toDate(),
      );

  Map<String, dynamic> toJson() => {
    'Id': Id,
    'address': address,
    'fullName': name,
    'profileImage': image,
    'email': email,
    'phoneNumber': phoneNumber,
    'isOnline': isOnline,
    'lastActive': lastActive,
  };
}

