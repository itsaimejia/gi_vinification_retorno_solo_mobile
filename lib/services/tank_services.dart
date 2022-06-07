// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/tank_model.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';

class TankServices extends ChangeNotifier {
  late CollectionReference collection;
  List<Tank> listData = [];
  bool loadData = true;
  TankServices() {
    collection = FirebaseFirestore.instance.collection('tanks');
  }

  Future getList() async {
    try {
      QuerySnapshot snapshot = await collection.get();
      if (snapshot.size > 0) {
        listData = snapshot.docs.map((doc) {
          final result = Tank.fromMap(doc.data() as Map<String, dynamic>);
          result.tankId = doc.id.toDecodeId();
          return result;
        }).toList();
      }
      print(listData);
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
      final snapshot = await collection.doc(id.toEncodeId()).get();
      if (snapshot.exists) {
        final response = Tank.fromMap(snapshot.data() as Map<String, dynamic>);
        response.tankId = snapshot.id.toDecodeId();
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> add(Tank data) async {
    try {
      await collection.doc(data.tankId?.toEncodeId()).set(data.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(Tank data) async {
    try {
      await collection.doc(data.tankId?.toEncodeId()).update(data.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await collection.doc(id.toEncodeId()).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
