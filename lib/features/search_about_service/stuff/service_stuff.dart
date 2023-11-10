import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceStuff {
  searchByService({
    required String val,
    required String currentUserEmail,
  }) async {
    List result = [];
    if (val.trim().isNotEmpty) {
      CollectionReference _collectionRef =
          FirebaseFirestore.instance.collection('Users');
      QuerySnapshot querySnapshot = await _collectionRef.get();
      List allData = querySnapshot.docs;
      for (QueryDocumentSnapshot item in allData) {
        if (checkUserContainService(item, val) && item['email'] != currentUserEmail) {
          print("----> item = ${item.id} -- ${item.data().toString()}");
          result.add(item);
        }
        /*for (var service in item['services']) {
          if (service.toString().toLowerCase().contains(val.toLowerCase()) &&
              !result.contains(item)) {
            result.add(item);
          }
        }*/
      }
      return result;
    }
    return result;
  }

  bool checkUserContainService(item, val) {
    for (var service in item['services']) {
      if (service.toString().toLowerCase().contains(val.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  searchByLocation({required String location, required String currentEmail}) async {
    List result = [];
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('Users');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs;
    for (QueryDocumentSnapshot item in allData) {
      if (checkUserContainThisLocation(item, location) && item['email'] != currentEmail) {
        print("----> item = ${item.id} -- ${item.data().toString()}");
        result.add(item);
      }
      /*for (var service in item['services']) {
          if (service.toString().toLowerCase().contains(val.toLowerCase()) &&
              !result.contains(item)) {
            result.add(item);
          }
        }*/
    }
    return result;
  }

  bool checkUserContainThisLocation(item, searchLocation) {
    for (var location in item['locations']) {
      if (location.toString().toLowerCase() == searchLocation.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
