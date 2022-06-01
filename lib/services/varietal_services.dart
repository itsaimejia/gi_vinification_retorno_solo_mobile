import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gi_vinification_retorno/models/varietal_model.dart';
import 'package:gi_vinification_retorno/styles/extensions.dart';

class VarietalServices extends ChangeNotifier {
  late CollectionReference collection;
  List<Varietal> listData = [];
  bool loadData = true;
  VarietalServices() {
    collection = FirebaseFirestore.instance.collection('varietals');
  }

  Future getList() async {
    try {
      QuerySnapshot snapshot = await collection.get();
      if (snapshot.size > 0) {
        listData = snapshot.docs.map((doc) {
          final result = Varietal.fromMap(doc.data() as Map<String, dynamic>);
          result.varietalId = doc.id.toDecodeId();
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
      final snapshot = await collection.doc(id.toEncodeId()).get();
      if (snapshot.exists) {
        final response =
            Varietal.fromMap(snapshot.data() as Map<String, dynamic>);
        response.varietalId = snapshot.id.toDecodeId();
        return response;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> add(Varietal data) async {
    try {
      await collection.doc(data.varietalId?.toEncodeId()).set(data.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(Varietal data) async {
    try {
      await collection.doc(data.varietalId?.toEncodeId()).update(data.toJson());
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
