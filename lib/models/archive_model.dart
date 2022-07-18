import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';
import 'package:flutter/foundation.dart';

class ArchiveModel extends Equatable {
  final String archiveUid;
  final String archiveId;
  final String parentLogUid;
  final String parentLogId;
  final DateTime date;
  final double waterLevel;
  final String note;

  const ArchiveModel({
    required this.archiveUid,
    required this.archiveId,
    required this.parentLogUid,
    required this.parentLogId,
    required this.date,
    required this.waterLevel,
    required this.note,
  });

  factory ArchiveModel.fromJson(Map<String, dynamic> json) {
    return ArchiveModel(
      archiveUid: json[FirebaseConstants.archiveUid],
      archiveId: json[FirebaseConstants.archiveId],
      parentLogUid: json[FirebaseConstants.parentLogUid],
      parentLogId: json[FirebaseConstants.parentLogId],
      date: (json[FirebaseConstants.date] as Timestamp).toDate(),
      waterLevel: json[FirebaseConstants.waterLevel],
      note: json[FirebaseConstants.note],
    );
  }

  static Map<String, dynamic> toJson(ArchiveModel model) {
    return {
      FirebaseConstants.archiveUid: model.archiveUid,
      FirebaseConstants.archiveId: model.archiveId,
      FirebaseConstants.parentLogUid: model.parentLogUid,
      FirebaseConstants.parentLogId: model.parentLogId,
      FirebaseConstants.date: model.date,
      FirebaseConstants.waterLevel: model.waterLevel,
      FirebaseConstants.note: model.note,
    };
  }

  static Map<String, dynamic> toJsonWithoutImages(ArchiveModel model) {
    return {
      FirebaseConstants.archiveUid: model.archiveUid,
      FirebaseConstants.archiveId: model.archiveId,
      FirebaseConstants.parentLogId: model.parentLogId,
      FirebaseConstants.parentLogUid: model.parentLogUid,
      FirebaseConstants.date: model.date,
      FirebaseConstants.waterLevel: model.waterLevel,
      FirebaseConstants.note: model.note,
    };
  }

  static ArchiveModel emptyArchive({required String parentLogUid, required String parentLogId, required String archiveUid}) {
    return ArchiveModel(
      archiveUid: archiveUid,
      archiveId: UniqueKey().toString(),
      parentLogUid: parentLogUid,
      parentLogId: parentLogId,
      date: DateTime.now(),
      waterLevel: 0,
      note: "",
    );
  }

  @override
  List<Object?> get props => [date, waterLevel, note];
}