// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gi_vinification_retorno/models/user_model.dart';

class DataUserServices extends ChangeNotifier {
  late CollectionReference collection;
  DataUserServices() {
    collection = FirebaseFirestore.instance.collection('users');
  }

  Future getByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await collection.get();
      final map = snapshot.docs;
      for (var m in map) {
        final result = DataUser.fromMap(m.data() as Map<String, dynamic>);
        result.uid = m.id;
        if (result.toString().contains(email)) {
          return result;
        }
      }
    } catch (e) {}
  }

  Future get(String uid) async {
    try {
      final snapshot = await collection.doc(uid).get();
      return snapshot.exists
          ? DataUser.fromMap(snapshot.data() as Map<String, dynamic>)
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> add(DataUser user) async {
    try {
      await collection.doc(user.uid).set(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(DataUser user) async {
    try {
      await collection.doc(user.uid).update(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(String uid) async {
    try {
      await collection.doc(uid).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
