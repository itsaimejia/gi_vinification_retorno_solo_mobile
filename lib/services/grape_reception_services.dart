// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:gi_vinification_retorno/models/grape_reception_model.dart';

class GrapeReceptionServices extends ChangeNotifier {
  late CollectionReference collection;
  List<GrapeReception> listData = [];
  bool loadData = true;
  GrapeReceptionServices() {
    collection = FirebaseFirestore.instance.collection('grape_reception');
  }

  Future getList() async {
    try {
      QuerySnapshot snapshot = await collection.get();

      if (snapshot.size > 0) {
        listData = snapshot.docs.map((doc) {
          final result =
              GrapeReception.fromMap(doc.data() as Map<String, dynamic>);
          result.id = doc.id;
          return result;
        }).toList();
      }
      loadData = false;
      notifyListeners();
    } catch (e) {
      loadData = false;
      notifyListeners();
    }
    loadData = false;
    notifyListeners();
  }

  Future get(String id) async {
    try {
      DocumentSnapshot<Object?> snapshot = await collection.doc(id).get();
      return snapshot.exists
          ? GrapeReception.fromMap(snapshot.data() as Map<String, dynamic>)
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> add(GrapeReception data) async {
    try {
      await collection.doc(data.id).set(data.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(GrapeReception data) async {
    try {
      await collection.doc(data.id).update(data.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await collection.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
