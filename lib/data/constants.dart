import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo_db;

List allPhotos = [];
List trending = [];
FocusNode searchNode = FocusNode();
mongo_db.DbCollection collection;
ValueNotifier<bool> refreshImages = ValueNotifier(false);

connectDB() async {
  var db = await mongo_db.Db.create(
      "mongodb+srv://username:qazwsxedc@cluster0.k4qilwf.mongodb.net/images?retryWrites=true&w=majority");
  await db.open();
  var coll = db.collection('all');
  collection = db.collection('all');
  allPhotos = await coll.find().toList();
  refreshImages.value = true;
}
