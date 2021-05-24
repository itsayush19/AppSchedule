

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_schedule_app/app/home/models/entry.dart';
import 'package:my_schedule_app/app/home/models/tasks.dart';
import 'package:my_schedule_app/app/services/api_path.dart';

abstract class Database {
  Future<void> createTask(Map<String, dynamic> taskData,String Id);
  Stream<List<Tasks>> readTask();
  Future<void> deleteTask(Tasks task);
  Future<void> createEntry(Map<String,dynamic> entryData,String entryId);
  Stream<List<Entry>> readEntry({Tasks task});
  Future<void> deleteEntry(Entry entry);
  Future<void> createThought(Map<String,dynamic> tht);
  Future<String> readThought();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  String DocId()=>DateTime.now().toIso8601String();
  String entId()=>DateTime.now().toIso8601String();

  @override
  Future<void> createTask(Map<String, dynamic> taskData,String Id) async {
    String path = APIpath.task(uid,Id);
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(taskData);
  }

  @override
  Future<void> createEntry(Map<String,dynamic> entryData,String entryId) async{
    String path=APIpath.entry(uid, entryId);
    final ref=FirebaseFirestore.instance.doc(path);
    await ref.set(entryData);
  }

  @override
  Stream<List<Tasks>> readTask(){
    String path=APIpath.tasks(uid);
    final reference=FirebaseFirestore.instance.collection(path);
    final snapshots=reference.snapshots();

    return snapshots.map(
            (snapshot) =>snapshot.docs.map(
                    (document)=>Tasks.fromMap(document.data(),document.id)
            ).toList(),
    );
  }


/*
 @override
  Stream<List<Entry>> entriesStream({Tasks task}) =>
      _collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: task != null
            ? (query) => query.where('taskId', isEqualTo: task.docId)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
 */
  Stream<List<T>> _collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }


  Stream<List<Entry>> readEntry({Tasks task}) =>
       _collectionStream<Entry>(
       path: APIpath.entries(uid),
       queryBuilder: task != null
           ? (query) => query.where('taskId', isEqualTo: task.docId.toString())
           : null,
       builder: (data, documentID) => Entry.fromMap(data, documentID),
       sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
  );

  Future<void> deleteEntry(Entry entry) async{
    String path=APIpath.entry(uid, entry.id);
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  @override
  Future<void> deleteTask(Tasks task) async{
    String path=APIpath.task(uid,task.docId);
    final ref=FirebaseFirestore.instance.doc(path);
    await ref.delete();
  }

  Future<void> createThought(Map<String,dynamic> tht) async{
    String tid='usertht';
    String path=APIpath.thought(uid, tid);
    final ref=FirebaseFirestore.instance.doc(path);
    await ref.set(tht);
  }

  Future<String> readThought() async{
    String paath=APIpath.thought(uid, 'usertht');
    final ref= await FirebaseFirestore.instance.doc(paath);
    final snapshot = ref.get();
    Future<String> data= snapshot.then(
            (value) => value.data().values.elementAt(0).toString()
    );
    return data;
  }
}
