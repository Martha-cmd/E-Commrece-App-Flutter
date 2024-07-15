import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//FUCTION TO STORE IMAGE IN FIREBASE STORAGE

  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('storeImages').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

//FUNTION TO STORE IMAGE IN FIREBASE STORAGE ENDS HERE

  //FUNCTION TO PICK STORE IMAGE
  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }


  Future<String> signUpVendors(String email, String password) async {
    String res = '';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        //Create the users

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        res = cred.user!.uid;
      } else {
        res = 'Please Fields must not be empty';
      }
    } catch (e) {}

    return res;
  }
  //FUNCTION TO PICK STORE IMAGE ENDS HERE

// FUCNTION TO SAVE VENDOR DATA
  Future<String> registerVendor(
      String userid,
    String bussinessName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    Uint8List? image,
  ) async {
    String res = 'some error occured';

    try {
      String storeImage = await _uploadVendorImageToStorage(image);
      //SAVE DATA TO CLOUD FIRESTORE

      await _firestore.collection('vendors').doc(userid).set({
        'bussinessName': bussinessName,
        'email': email,
        'phoneNumber': phoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'storeImage': storeImage,
        'approved': false,
        'vendorId': _auth.currentUser!.uid,
      });
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //FUNCTION TO SAVE VENDOR DATA ENDS HERE

  loginvendor(String email, String password) async {
    String res = 'something went wrong';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = 'success';

      } else {
        res = 'Please Fields must not be empty';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
