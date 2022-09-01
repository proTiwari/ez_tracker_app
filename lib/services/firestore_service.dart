import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';

class FireStoreEndPoints {
  FireStoreEndPoints._();
  static const users = 'Users';
  static const subCategories = 'SubCategories';
  static const driveRecords = 'DriveRecords';
}

class FireStoreService {
  FireStoreService._();
  static final instance = FireStoreService._();

  Future<List<T>> collectionFuture<T>({
    required String path,
    required T Function(dynamic data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot snapshots = await query.get();
    final result = snapshots.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList();

    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  // Used to apply query and get data from firestore.
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(dynamic data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
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
      print("$result");
      return result;
    });
  }

  // Used to set data to firestore.
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool withMerge = false,
  }) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    UtilityHelper.showLog('$path : $data');
    await documentReference.set(data, SetOptions(merge: withMerge));
  }

  // Used to set data to firestore.
  // Future<void> setData({
  //   required String path,
  //   required Map<String, dynamic> data,
  //   bool withMerge = false,
  // }) async {
  //   final documentReference =
  //       await FirebaseFirestore.instance.collection(path).add(data);
  //   UtilityHelper.showLog('$path : $data');
  //   await documentReference.set(data, SetOptions(merge: withMerge));
  // }

  // Used to delete data from firestore.
  Future<void> deleteData({required String path}) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    UtilityHelper.showLog('Deleted path: $path');
    await documentReference.delete();
  }

  // Used to get documens of dynamic type from firestore.
  Stream<T> documentsStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String docId) builder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Future<T> documentsFuture<T>({
    required String path,
    required T Function(
      Map<String, dynamic>? data,
      String docId,
    )
        builder,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    UtilityHelper.showLog('documents path: $path');
    final response = await snapshots
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .first;
    UtilityHelper.showLog('documents response: ${response.toString()}');
    return response;
  }
}
