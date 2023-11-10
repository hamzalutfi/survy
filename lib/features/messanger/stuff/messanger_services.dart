import 'package:cloud_firestore/cloud_firestore.dart';

class MessengerServices {
  Future createChatRoom(String chatRoomId, chatRoomMap) async {
    return await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((ex) async {
      print("chat room error : ${ex}");
      // if(ex.toString() == "[cloud_firestore/not-found] Some requested document was not found."){
      //   return await FirebaseFirestore.instance
      //       .collection("chat_rooms")
      //       .doc(chatRoomId)
      //       .update(chatRoomMap);
      // }
    });
  }

  Future addConversationMessages(
      String chatRoomId, Map<String, dynamic> messageMap) async {
    if (messageMap['type'] == "text") {
      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .add({
        'message': messageMap['message'],
        'sendBy': messageMap['sendBy'],
        'date': DateTime.now().millisecondsSinceEpoch,
        'type': messageMap['type'], // offer, photo ...
        'period': "-",
        "budget": "-",
        "service": null
      }).catchError((ex) {
        print("error in add conversation message : $ex");
      });
      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .update({
        'last_date_messaging': DateTime.now().millisecondsSinceEpoch,
        'last_message': messageMap['message']
      });
    } else {
      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .add({
        'message': messageMap['message'],
        'sendBy': messageMap['sendBy'],
        'date': DateTime.now().millisecondsSinceEpoch,
        'type': messageMap['type'], // offer, photo ...
        'period': messageMap['period'],
        "budget": messageMap['budget'],
        "service": messageMap['service'],

      }).catchError((ex) {
        print("error in add conversation message : $ex");
      });
      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .update({
        'last_date_messaging': DateTime.now().millisecondsSinceEpoch,
        'last_message': "New offer!"
      });
    }
  }

  Future getConversationMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future getChatRoomsMember(String email) async {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .where('users', arrayContains: email)
        .snapshots();
  }

  deleteOffer(chatRoomId, docForDelete) {
    print("---> chatRoomId = $chatRoomId");
    print("---> docForDelete = $docForDelete");
    FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection("messages")
        .doc(docForDelete)
        .delete().catchError((e){
          print("----> e = ${e.toString()}");
    });
  }
}
