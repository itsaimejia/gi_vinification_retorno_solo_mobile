// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/analisis_model.dart';

class AnalisisServices extends ChangeNotifier {
  late CollectionReference collection;
  List<Analisis> listData = [];
  bool loadData = true;
  AnalisisServices() {
    collection = FirebaseFirestore.instance.collection('analisis');
  }
  Future getList() async {
    try {
      QuerySnapshot snapshot = await collection.get();
      if (snapshot.size > 0) {
        listData = snapshot.docs.map((doc) {
          final result = Analisis.fromMap(doc.data() as Map<String, dynamic>);
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
  }

  Future get(String id) async {
    try {
      final snapshot = await collection.doc(id).get();
      return snapshot.exists
          ? Analisis.fromMap(snapshot.data() as Map<String, dynamic>)
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> add(Analisis data) async {
    try {
      await collection.doc(data.id).set(data.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(Analisis data) async {
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
