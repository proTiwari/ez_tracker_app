import 'package:ez_tracker_app/utils/utility_helper.dart';

enum RecordStatusType {
  unclassified, // id 1
  completed, // id 2
}

extension RecordStatusTypeExt on RecordStatusType {
  int get id {
    switch (this) {
      case RecordStatusType.unclassified:
        return 1;
      case RecordStatusType.completed:
        return 2;
    }
  }
}

class TrackerRecordModel {
  final String? recordId;
  final String? userId;
  double? ratings;
  final DateTime? recordCreatedDate;
  final LatLongModel? sourceDetails;
  final LatLongModel? destinationDetails;
  String? primaryCategory;
  String? subCategory;
  final int? statusID;

  RecordStatusType get recordStatusType {
    switch (statusID) {
      case 1:
        return RecordStatusType.unclassified;
      case 2:
        return RecordStatusType.completed;
    }
    return RecordStatusType.unclassified;
  }

  TrackerRecordModel({
    this.recordId,
    this.userId,
    this.ratings,
    this.recordCreatedDate,
    this.sourceDetails,
    this.destinationDetails,
    this.primaryCategory,
    this.subCategory,
    this.statusID,
  });

  TrackerRecordModel copyWith({
    String? recordId,
    String? userId,
    double? ratings,
    DateTime? recordCreatedDate,
    LatLongModel? sourceDetails,
    LatLongModel? destinationDetails,
    String? primaryCategory,
    String? subCategory,
    int? statusID,
  }) {
    return TrackerRecordModel(
      recordId: recordId ?? this.recordId,
      userId: userId ?? this.userId,
      ratings: ratings ?? this.ratings,
      recordCreatedDate: recordCreatedDate ?? this.recordCreatedDate,
      sourceDetails: sourceDetails ?? this.sourceDetails,
      destinationDetails: destinationDetails ?? this.destinationDetails,
      primaryCategory: primaryCategory ?? this.primaryCategory,
      subCategory: subCategory ?? this.subCategory,
      statusID: statusID ?? this.statusID,
    );
  }

  String get distanceInMiles => UtilityHelper.distanceInMiles(
        lat1: sourceDetails?.lat ?? 0,
        lon1: sourceDetails?.long ?? 0,
        lat2: destinationDetails?.lat ?? 0,
        lon2: destinationDetails?.long ?? 0,
      );

  String get potentialPrice => '${100 * (ratings ?? 0)}';

  factory TrackerRecordModel.fromMap(
      Map<String, dynamic>? data, String recordId) {
    return TrackerRecordModel(
      recordId: recordId,
      userId: data?['userid'],
      ratings: data?['ratings'],
      recordCreatedDate: (data?['record_created_date'] != null)
          ? DateTime.parse(data?['record_created_date'])
          : null,
      sourceDetails: (data?['source_details'] != null)
          ? LatLongModel.fromMap(data?['source_details'])
          : null,
      destinationDetails: (data?['destination_details'] != null)
          ? LatLongModel.fromMap(data?['destination_details'])
          : null,
      primaryCategory: data?['primary_category'],
      subCategory: data?['sub_category'],
      statusID: data?['status_id'],
    );
  }

  Map<String, dynamic> toMap({required String recordId}) {
    return {
      'recordId': recordId,
      if (userId != null) 'userid': userId,
      if (ratings != null) 'ratings': ratings,
      if (recordCreatedDate != null)
        'record_created_date': recordCreatedDate?.toIso8601String(),
      if (primaryCategory != null) 'primary_category': primaryCategory,
      if (subCategory != null) 'sub_category': subCategory,
      if (statusID != null) 'status_id': statusID,
      if (sourceDetails != null) 'source_details': sourceDetails?.toMap(),
      if (destinationDetails != null)
        'destination_details': destinationDetails?.toMap(),
    };
  }

  // @override
  // String toString() {
  //   return '**RecordId:$recordId';
  // }
}

class LatLongModel {
  final DateTime? createdDate;
  final double? lat;
  final double? long;

  LatLongModel({
    this.createdDate,
    this.lat,
    this.long,
  });

  factory LatLongModel.fromMap(Map<String, dynamic>? data) {
    return LatLongModel(
      createdDate: (data?['created_date'] != null)
          ? DateTime.parse(data?['created_date'])
          : null,
      lat: data?['latitude'],
      long: data?['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (createdDate != null) 'created_date': createdDate?.toIso8601String(),
      if (lat != null) 'latitude': lat,
      if (long != null) 'longitude': long,
    };
  }

  @override
  String toString() {
    return '**CreatedDate:$createdDate\n**Latitude$lat\n**Longitude$long';
  }
}
