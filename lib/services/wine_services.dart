import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/wine_model.dart';

class WineServices extends ChangeNotifier {
  late CollectionReference collection;
  List<Wine> listData = [];
  bool loadData = true;
  WineServices() {
    collection = FirebaseFirestore.instance.collection('wines');
  }

  Future getList() async {
    try {
      QuerySnapshot snapshot = await collection.get();
      if (snapshot.size > 0) {
        listData = snapshot.docs.map((doc) {
          final result = Wine.fromMap(doc.data() as Map<String, dynamic>);
          result.id = doc.id;
          result.blem = result.blem;
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
      final snapshot = await collection.doc(id).get();
      return snapshot.exists
          ? Wine.fromMap(snapshot.data() as Map<String, dynamic>)
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> add(Wine data) async {
    try {
      await collection.doc(data.id).set(data.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(Wine data) async {
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
