import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:we_map/constants/firebase_constants.dart';
import 'package:flutter/foundation.dart';

class ArchiveModel extends Equatable {
  final String parentLogId;
  final String archiveId;
  final DateTime date;
  final double waterLevel;
  final String note;

  const ArchiveModel({
    required this.parentLogId,
    required this.archiveId,
    required this.date,
    required this.waterLevel,
    required this.note,
  });

  factory ArchiveModel.fromJson(Map<String, dynamic> json) {
    return ArchiveModel(
      archiveId: json[FirebaseConstants.archiveId],
      parentLogId: json[FirebaseConstants.parentLogId],
      date: (json[FirebaseConstants.date] as Timestamp).toDate(),
      waterLevel: json[FirebaseConstants.waterLevel],
      note: json[FirebaseConstants.note],
    );
  }

  static Map<String, dynamic> toJson(ArchiveModel model) {
    return {
      FirebaseConstants.parentLogId: model.parentLogId,
      FirebaseConstants.archiveId: model.archiveId,
      FirebaseConstants.date: model.date,
      FirebaseConstants.waterLevel: model.waterLevel,
      FirebaseConstants.note: model.note,
    };
  }

  static Map<String, dynamic> toJsonWithoutImages(ArchiveModel model) {
    return {
      FirebaseConstants.parentLogId: model.parentLogId,
      FirebaseConstants.archiveId: model.archiveId,
      FirebaseConstants.date: model.date,
      FirebaseConstants.waterLevel: model.waterLevel,
      FirebaseConstants.note: model.note,
    };
  }

  static ArchiveModel emptyArchive(String parentLogId) {
    return ArchiveModel(
      archiveId: UniqueKey().toString(),
      parentLogId: parentLogId,
      date: DateTime.now(),
      waterLevel: 0,
      note: "",
    );
  }

  @override
  List<Object?> get props => [date, waterLevel, note];
}