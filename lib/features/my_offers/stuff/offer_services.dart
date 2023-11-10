import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wego/entities/user_entity.dart';

class OfferServices {
  createOffer({
    required String ownerName,
    required String content,
    required String budget,
    required String period,
    required String uid,
    required int length,
    required String email,
    required String profileURL
  }) {
    FirebaseFirestore.instance
        .collection('Users/$uid/offers')
        .doc("${uid}_N_${(length + 1)}")
        .set({
      'budget': budget,
      'content': content,
      'created_at': DateTime.now().toString().substring(0, 10),
      'owner_name': ownerName,
      'period': period,
      'email': email,
      "profileURL": profileURL
    });

    FirebaseFirestore.instance
        .collection('public_offers')
        .doc("${uid}_N_${(length + 1)}")
        .set({
      'budget': budget,
      'content': content,
      'created_at': DateTime.now().toString().substring(0, 10),
      'owner_name': ownerName,
      'period': period,
      'email': email,
      "profileURL": profileURL
    });
  }

  editOffer({
    required String ownerName,
    required String content,
    required String budget,
    required String period,
    required String uid,
    required String documentIdForEdit,
    required int length,
  }) {
    FirebaseFirestore.instance
        .collection('Users/$uid/offers')
        .doc(documentIdForEdit)
        .update({
      'budget': budget,
      'content': content,
      'created_at': DateTime.now().toString().substring(0, 10),
      'owner_name': ownerName,
      'period': period,
    });

    FirebaseFirestore.instance
        .collection('public_offers')
        .doc(documentIdForEdit)
        .set({
      'budget': budget,
      'content': content,
      'created_at': DateTime.now().toString().substring(0, 10),
      'owner_name': ownerName,
      'period': period,
    });
  }

  deleteOffer(item, UserEntity currentUser){
    FirebaseFirestore.instance
        .collection('Users/${currentUser.token}/offers')
        .doc("${item.id}")
        .delete();
  }
}
