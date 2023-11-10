import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePhotoService {
  static getUserPhoto(String email) async {
    String docId = await getUserDocument(email);
    if (docId.isNotEmpty) {
      final doc =
          await FirebaseFirestore.instance.collection('Users').doc(docId).get();
      print("---> doc['profileURL'] = ${doc['profileURL']}");
      return doc['profileURL'];
    } else {
      return "";
    }
  }

  static Future<String> getUserDocument(String email) async {
    QuerySnapshot userOffersQ =
        await FirebaseFirestore.instance.collection('Users').get();

    for (var item in userOffersQ.docs) {
      if (item['email'] == email) {
        return item.id;
      }
    }
    return "";
  }
}
